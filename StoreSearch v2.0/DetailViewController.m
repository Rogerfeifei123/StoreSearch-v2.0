//
//  DetailViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 04/12/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResult.h"


@interface DetailViewController ()<UIGestureRecognizerDelegate>
@property(weak,nonatomic)IBOutlet UIView*popupView;
@property(weak,nonatomic)IBOutlet UIImageView*imageView;
@property(weak,nonatomic)IBOutlet UILabel*nameLabel;
@property(weak,nonatomic)IBOutlet UILabel*artistLabel;
@property(weak,nonatomic)IBOutlet UILabel*kindLabel;
@property(weak,nonatomic)IBOutlet UILabel*genreLabek;
@property(weak,nonatomic)IBOutlet UIButton*priceButton;

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //The UIEdgeInsetMake method is to decide which part of the image is going to be stretched,the four number is anticlockwise with (top/ left/ bottom/ right)the detail number decide the distance to the edge
    UIImage *image = [[UIImage imageNamed:@"PriceButton-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.popupView.layer.cornerRadius=10.0f;
    self.view.tintColor=[UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f];
    
    UITapGestureRecognizer*tapgestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    tapgestureRecognizer.cancelsTouchesInView=NO;
    tapgestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapgestureRecognizer];
    
    if (self.searchResult!=nil) {
        [self updateUI];
    }
}

//NameLbael--result.name
//artistLabel--result.artist
//kindLabel--result.kind
//genreLabel--result.genre
//priceButton--result.price
-(void)updateUI
{
    self.nameLabel.text=self.searchResult.name;
    self.artistLabel.text=self.searchResult.artistName;
    if (self.artistLabel.text==nil) {
        self.artistLabel.text=@"Unknow";
    }
    self.kindLabel.text=[self.searchResult kindForDisplay];
    self.genreLabek.text=self.searchResult.genre;
    
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (self.view==touch.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}


-(IBAction)close:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


@end
