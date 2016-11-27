//
//  SearchViewController.m
//  StoreSearch v2.0
//
//  Created by ZhuRoger on 25/11/2016.
//  Copyright © 2016 ZhuRoger. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultTableViewCell.h"

 static NSString*const searchResultCellIdentifer=@"SearchResultCell";
 static NSString*const nothingFoundCellIdentifer=@"NothingFoundCell";

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
    self.tableView.rowHeight=80;
    self.tableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    UINib*cellNib=[UINib nibWithNibName:searchResultCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:searchResultCellIdentifer];
    cellNib=[UINib nibWithNibName:nothingFoundCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:nothingFoundCellIdentifer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([_searchResults count]==0)
    {
        return [tableView dequeueReusableCellWithIdentifier:nothingFoundCellIdentifer];
    }else
    {
        SearchResultTableViewCell*cell=(SearchResultTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifer];
    SearchResult*searchResult=_searchResults[indexPath.row];
        cell.nameLabel.text=searchResult.name;
        cell.artistNameLabel.text=searchResult.artistName;
        return cell;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchResults==nil) {
        return 0;
    }else if ([_searchResults count]==0){
        return 1;
    }else{
        return _searchResults.count;
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
    if (![self.searchBar.text isEqualToString:@"Je"])
    {
        for (int i=0; i<3; i++)
        {
            SearchResult*searchResult=[[SearchResult alloc]init];
            searchResult.name=[NSString stringWithFormat:@"Fake result %d for",i];
            searchResult.artistName=searchBar.text;
            [_searchResults addObject:searchResult];
        }
    }
       [self.tableView reloadData];
}

@end
