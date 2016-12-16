//
//  LandScapeViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 11/12/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "LandScapeViewController.h"
#import "SearchResult.h"

@interface LandScapeViewController ()
@property(nonatomic,weak)IBOutlet UIPageControl*pageControl;
@property(nonatomic,weak)IBOutlet UIScrollView*scrollView;

@end

@implementation LandScapeViewController
{
    BOOL _firstTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground-1"]];
    //self.scrollView.contentSize=CGSizeMake(1000, self.scrollView.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
