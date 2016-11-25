//
//  AppDelegate.h
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 25/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

