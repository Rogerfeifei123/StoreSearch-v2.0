//
//  SearchViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 25/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,weak)IBOutlet UISearchBar*searchBar;
@property(nonatomic,weak)IBOutlet UITableView*tableView;
@end

@implementation SearchViewController
{
    NSMutableArray*_searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar becomeFirstResponder];
    self.tableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIdentifer=@"SearchResultCell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text=_searchResults[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_searchResults.count)
    {
        return 0;
    }else
    {
        return [_searchResults count];
    }
}

#pragma mark - UItableviewDelegate
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchResults=[NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<3; i++)
    {
        [_searchResults addObject:[NSString stringWithFormat:@"Fake result for %d %@",i,searchBar.text]];
    }
    [self.tableView reloadData];
}

@end
