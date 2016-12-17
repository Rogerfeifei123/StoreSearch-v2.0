//
//  LandScapeViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 11/12/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "LandScapeViewController.h"
#import "SearchResult.h"
#import <AFNetworking/UIButton+AFNetworking.h>

@interface LandScapeViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)IBOutlet UIPageControl*pageControl;
@property(nonatomic,weak)IBOutlet UIScrollView*scrollView;

@end

@implementation LandScapeViewController
{
    BOOL _firstTime;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _firstTime=YES;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground-1"]];
    //self.scrollView.contentSize=CGSizeMake(1000, self.scrollView.bounds.size.height);
    self.pageControl.numberOfPages=0;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_firstTime) {
        _firstTime=NO;
        [self titleButtons];
    }
}

-(void)downloadImageForSearchResult:(SearchResult*)searchResult andPlaceOnButton:(UIButton*)button
{
    NSURL*url=[NSURL URLWithString:searchResult.artworkURL60];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak UIButton*weakButton=button;
    
    [button setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:nil success:^(NSURLRequest*request,NSHTTPURLResponse*response,UIImage*image){
        UIImage*unscaledImage=[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:image.imageOrientation];
        [weakButton setImage:unscaledImage forState:UIControlStateNormal];
    } failure:nil];
}

-(void)titleButtons
{
    int columnsPerpage=5;
    CGFloat itemWidth=96.0f;
    CGFloat x=0.0f;
    CGFloat extraSpace=0.0f;
    
    CGFloat scrollViewWidth=self.scrollView.bounds.size.width;
    if (scrollViewWidth>480.0f) {
        columnsPerpage=6;
        itemWidth=94.0f;
        x=2.0f;
        extraSpace=4.0f;
    }
    
    const CGFloat itemHeight=88.0f;
    const CGFloat buttonWidth=82.0f;
    const CGFloat buttonHeight=82.0f;
    const CGFloat marginHorz=(itemWidth-buttonWidth)/2.0f;
    const CGFloat marginVert=(itemHeight-buttonHeight)/2.0f;
    
    int index=0;
    int row=0;
    int column=0;
    
    for (SearchResult*searchResult in self.searchResult) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton-1"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",index] forState:UIControlStateNormal];
        [self downloadImageForSearchResult:searchResult andPlaceOnButton:button];
        
        button.frame=CGRectMake(x+marginHorz, 20.0f+row*itemHeight+marginVert,buttonWidth , buttonHeight);
        
        [self.scrollView addSubview:button];
        
        index++;
        row++;
        if (row==3) {
            row=0;
            column++;
            x+=itemWidth;
            if (column==columnsPerpage) {
                column=0;
                x+=extraSpace;
            }
        }
    }
    int tilesPerpage=columnsPerpage*3;
    int numPages=ceilf([self.searchResult count]/(float)tilesPerpage);
    self.scrollView.contentSize=CGSizeMake(numPages*scrollViewWidth, self.scrollView.bounds.size.height);
    NSLog(@"%d",numPages);
    
    self.pageControl.numberOfPages=numPages;
    self.pageControl.currentPage=0;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width=self.scrollView.bounds.size.width;
    int currentPgae=(self.scrollView.contentOffset.x+width/2.0f)/width;
    self.pageControl.currentPage=currentPgae;
}

-(IBAction)pageChanged:(UIPageControl*)sender
{
    self.scrollView.contentOffset=CGPointMake(self.scrollView.bounds.size.width*sender.currentPage, 0);
}

-(void)dealloc
{
    NSLog(@"Declloc %@",self);
    for (UIButton*button in self.scrollView.subviews) {
        [button cancelImageRequestOperationForState:UIControlStateNormal];
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
