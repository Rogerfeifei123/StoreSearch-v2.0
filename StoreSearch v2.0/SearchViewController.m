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
#import "SearchViewController.h"
#import "DetailViewController.h"
#import <AFNetworking.h>

 static NSString*const searchResultCellIdentifer=@"SearchResultCell";
 static NSString*const nothingFoundCellIdentifer=@"NothingFoundCell";
 static NSString*const loadingCellIdentifer=@"LoadingCell";

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,weak)IBOutlet UISearchBar*searchBar;
@property(nonatomic,weak)IBOutlet UITableView*tableView;
@property(nonatomic,weak)IBOutlet UISegmentedControl*segmentedControl;
@end

@implementation SearchViewController
{
    NSMutableArray*_searchResults;
    BOOL _isLoading;
    NSOperationQueue*_queue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _queue=[[NSOperationQueue alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.rowHeight=80;
    self.tableView.contentInset=UIEdgeInsetsMake(108, 0, 0, 0);
    
    
    
    UINib*cellNib=[UINib nibWithNibName:searchResultCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:searchResultCellIdentifer];
    
    cellNib=[UINib nibWithNibName:nothingFoundCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:nothingFoundCellIdentifer];
    
    cellNib=[UINib nibWithNibName:loadingCellIdentifer bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:loadingCellIdentifer];
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLoading){
        return 1;
    } else if (_searchResults==nil){
        return 0;
    }else if ([_searchResults count]==0){
        return 1;
    }else{
        return [_searchResults count];
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)ndexPath
{
    
    if (_isLoading)
    {
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:loadingCellIdentifer forIndexPath:(NSIndexPath*)ndexPath];
        //UIActivityIndicatorView*spinner=(UIActivityIndicatorView*)[cell viewWithTag:100];
        //[spinner startAnimating];
        return cell;
    }else if ([_searchResults count]==0)
    {
        return [tableView dequeueReusableCellWithIdentifier:nothingFoundCellIdentifer forIndexPath:(NSIndexPath*)ndexPath];
    }else
    {
        SearchResultTableViewCell*cell=(SearchResultTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifer forIndexPath:(NSIndexPath*)ndexPath];
        SearchResult*searchResult=_searchResults[ndexPath.row];
        [cell configureForSearchResult:searchResult];
        return cell;
    }
}




#pragma mark - UItableviewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController*controller=[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
   
    SearchResult*result=_searchResults[indexPath.row];
    controller.searchResult=result;
    //self is equal to "DetailViewControlelr"
    //controller-->"DetailViewController"
    //parentViewController-->"SearchViewControler"
    //The method means that the detailViewController present in the ParentViewControler(SearchViewController)
    [controller presentInParentViewController:self];
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchResults count] ==0 ||_isLoading) {
        return nil;
    }else{
        return indexPath;
    }
}

#pragma mark - UISearchBarDelegate
-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
}

-(void)performSearch
{
    if ([self.searchBar.text length]>0)
    {
       [_queue cancelAllOperations];
        [self.searchBar resignFirstResponder];
        _isLoading=YES;
        [self.tableView reloadData];
    
        _searchResults=[NSMutableArray arrayWithCapacity:10];
        NSURL*url=[self urlwithSearchText:self.searchBar.text category:self.segmentedControl.selectedSegmentIndex];
        NSURLRequest*request=[NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation*operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer=[AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation*operation, id responseObject)
         {
            [self parseDictionary:responseObject];
            [_searchResults sortUsingSelector:@selector(compareName:)];
            _isLoading=NO;
            [self.tableView reloadData];
         }
        failure:^(AFHTTPRequestOperation*operation,NSError*error){
            if (operation.isCancelled) {
               return ;
            }
            [self showNetWorkError];
            _isLoading=NO;
            [self.tableView reloadData];
        }];
        [_queue addOperation:operation];
    }
}




//change the format of the inputtext to valid format
-(NSURL*)urlwithSearchText:(NSString*)searchText category:(NSInteger)category{
    NSString*categoryName;
    switch (category) {
        case 0:categoryName=@"";
            break;
        case 1:categoryName=@"musicTrack";
            break;
        case 2: categoryName = @"software";
            break;
        case 3: categoryName = @"ebook";
            break;
    }
    
    NSString*allowedCharactors=[searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString*urlString=[NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&entity=%@",allowedCharactors,categoryName];
    NSURL*url=[NSURL URLWithString:urlString];
    return url;
}



//Parse NSDictionary to searchResult
-(void)parseDictionary:(NSDictionary*)dictionary
{
    NSArray*array=dictionary [@"results"];
    if (array==nil)
    {
        NSLog(@"Expected results error");
        return;
    }
    
    //use a for-loop to add the searchResult into _searchResult
    for (NSDictionary*resultDic in array)
    {
        NSLog(@"WrapperType: %@ kind: %@",resultDic[@"wrapperType"],resultDic[@"kind"]);
        SearchResult*searchResult;
        NSString*wrapperType=resultDic[@"wrapperType"];
        
        if ([wrapperType isEqualToString:@"track"])
        {
            searchResult=[self parseTrack:resultDic];
        }else if ([wrapperType isEqualToString:@"audiobook"]){
            searchResult=[self parseAudioBook:resultDic];
        }else if ([wrapperType isEqualToString:@"software"]){
            searchResult=[self parseSoftware:resultDic];
        }else if ([wrapperType isEqualToString:@"ebook"]){
            searchResult=[self parseSoftware:resultDic];
        }
        if (searchResult!=nil) {
            [_searchResults addObject:searchResult];
        }
    }
}

//give a alert to the user when the network doesn't work well
-(void)showNetWorkError
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"Whoops...." message:@"There are something wrong with the network" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(SearchResult*)parseTrack:(NSDictionary*)dictionary
{
    SearchResult*searchResult=[[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

-(SearchResult*)parseSoftware:(NSDictionary*)dictionary
{
    SearchResult*searchResult=[[SearchResult alloc]init];
    searchResult.name=dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    
    
    return searchResult;
}

-(SearchResult*)parseAudioBook:(NSDictionary*)dictionary
{
    SearchResult*searchResult=[[SearchResult alloc]init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
  
    return searchResult;
}

-(SearchResult*)parseEBook:(NSDictionary*)dictionary
{
    SearchResult*searchResult=[[SearchResult alloc]init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"]componentsJoinedByString:@", "];

    return searchResult;

}

-(IBAction)segmentChanged:(UISegmentedControl*)sender
{
    if (_searchResults!=nil) {
        [self performSearch];
    }
}

@end


