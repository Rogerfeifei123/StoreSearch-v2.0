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
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()<UIGestureRecognizerDelegate,CAAnimationDelegate>
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
    
    self.view.backgroundColor=[UIColor clearColor];
    
    //The UIEdgeInsetMake method is to decide which part of the image is going to be stretched,the four number is anticlockwise with (top/ left/ bottom/ right)the detail number decide the distance to the edge
    UIImage *image = [[UIImage imageNamed:@"PriceButton-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.popupView.layer.cornerRadius=10.0f;
    self.view.tintColor=[UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f];
    [self.priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    UITapGestureRecognizer*tapgestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    tapgestureRecognizer.cancelsTouchesInView=NO;
    tapgestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapgestureRecognizer];
    
    if (self.searchResult!=nil) {
        [self updateUI];
    }
    
}

-(void)updateUI
{
    self.nameLabel.text=self.searchResult.name;
    self.artistLabel.text=self.searchResult.artistName;
    if (self.artistLabel.text==nil) {
        self.artistLabel.text=@"Unknow";
    }
    self.kindLabel.text=[self.searchResult kindForDisplay];
    self.genreLabek.text=self.searchResult.genre;
    
    NSNumberFormatter*numberFormatter=[[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.searchResult.currency];
    
    NSString*priceText;
    if ([self.searchResult.price floatValue]==0.0f) {
        priceText=@"Free";
    }else{
        priceText=[numberFormatter stringFromNumber:self.searchResult.price];
    }
    [self.priceButton setTitle:[NSString stringWithFormat:@"%@",priceText] forState:UIControlStateNormal];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkURL100]];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (self.view==touch.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

-(IBAction)openInStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL] options:@{} completionHandler:nil];
    NSLog(@"URL is %@",self.searchResult.storeURL);
    
}

-(IBAction)close:(id)sender
{
    [self dismissFromParentViewController];
    
}

-(void)dismissFromParentViewController
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

//DetailViewControlelr (child)   SearchViewController(parent)
-(void)presentInParentViewController:(UIViewController *)parentViewController
{
    self.view.frame=parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    CAKeyframeAnimation*bounceAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

    bounceAnimation.duration=0.4;
    bounceAnimation.delegate=self;
    
    bounceAnimation.values=@[@0.7,@1.2,@0.9,@1.0];
    bounceAnimation.keyTimes=@[@0.0,@0.334,@0.666,@1.0];
    
    bounceAnimation.timingFunctions=@[
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
}

-(void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

-(void)dealloc
{
    [self.imageView cancelImageRequestOperation];
    NSLog(@"Dealloc %@",self);
}


@end
