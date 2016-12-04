//
//  SearchResultTableViewCell.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 27/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "SearchResultTableViewCell.h"
#import "SearchResult.h"

#import <UIImageView+AFNetworking.h>

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView*selectView=[[UIView alloc] initWithFrame:CGRectZero];
    selectView.backgroundColor=[UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5f];
    self.selectedBackgroundView=selectView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text=searchResult.name;
    NSString*artistName=searchResult.artistName;
    if (artistName==nil) {
        artistName=@"Unknow";
    }
    NSString*kind=searchResult.kind;
    self.artistNameLabel.text=[NSString stringWithFormat:@"%@(%@)",artistName,kind];
    [self.artistWorkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.artistWorkImageView cancelImageRequestOperation];
    self.artistNameLabel.text=nil;
    self.nameLabel.text=nil;
}

@end
