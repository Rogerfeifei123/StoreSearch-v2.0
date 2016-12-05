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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //The UIEdgeInsetMake method is to decide which part of the image is going to be stretched,the four number is anticlockwise with (top/ left/ bottom/ right)the detail number decide the distance to the edge
    UIImage *image = [[UIImage imageNamed:@"PriceButton-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    self.popupView.layer.cornerRadius=10.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}


-(IBAction)closeView:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


@end
