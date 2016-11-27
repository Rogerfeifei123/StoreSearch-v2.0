//
//  SearchResultTableViewCell.h
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 27/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView*artistWorkImageView;
@property(nonatomic,weak)IBOutlet UILabel*nameLabel;
@property(nonatomic,weak)IBOutlet UILabel*artistNameLabel;

@end
