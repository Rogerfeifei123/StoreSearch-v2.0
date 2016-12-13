//
//  DetailViewController.h
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 04/12/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

typedef NS_ENUM(NSInteger,DetailViewControllerAnimationType){
    DetailViewControllerAnimationTypeSlide,
    DetailViewControllerAnimationTypeFade
};

@interface DetailViewController : UIViewController

@property(nonatomic,strong)SearchResult*searchResult;

-(void)presentInParentViewController:(UIViewController*)parentViewController;
-(void)dismissFromParentViewControllerAnimationType:(DetailViewControllerAnimationType)animaitonType;

@end
