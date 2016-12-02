//
//  SearchResult.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 25/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell
-(NSComparisonResult)compareName:(SearchResultCell *)other
{
    return [self.name localizedStandardCompare:other.name];
}
@end
