//
//  DetailViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 04/12/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property(weak,nonatomic)IBOutlet UIView*popupView;
@property(weak,nonatomic)IBOutlet UIImageView*imageView;
@property(weak,nonatomic)IBOutlet UILabel*nameLabel;
@property(weak,nonatomic)IBOutlet UILabel*artistLabel;
@property(weak,nonatomic)IBOutlet UILabel*kindLabel;
@property(weak,nonatomic)IBOutlet UILabel*genreLabek;
@property(weak,nonatomic)IBOutlet UIButton*priceButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [[UIImage imageNamed:@"PriceButton-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)closeView:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
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
