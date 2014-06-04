//
//  MainViewController.m
//  TableviewSearch
//
//  Created by qianfeng1 on 14-1-8.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    NSMutableArray *_dataArray;
    UISearchBar *_searchBar;
    UITableView *_tableView;
    NSMutableArray *_resultArray;
}

-(void)dealloc
{
    [super dealloc];
    [_dataArray release];
    [_searchBar release];
    [_tableView release];
    [_resultArray release];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _resultArray = [[NSMutableArray alloc] init];
    
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (int j = 0; j < 2; j++) {
            NSString * str =[NSString stringWithFormat:@"%c-%d",'A'+i, j];
            [arr addObject:str];
        }
        [_dataArray addObject:arr];
        [arr release];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
    //设置编辑按钮。
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tableView.tableHeaderView = _searchBar;
    
    UISearchDisplayController *sdc = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    sdc.searchResultsDataSource = self;
    sdc.searchResultsDelegate = self;
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%c---Header",'A'+section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView != _tableView)
    {
        [_resultArray removeAllObjects];
        for(NSArray * arr in _dataArray)
        {
            for(NSString * str in arr)
            {
                if([[str uppercaseString] rangeOfString:[_searchBar.text uppercaseString]].location != NSNotFound)
                {
                    [_resultArray addObject:str];
                }
            }
        }
        return [_resultArray count];
    }
    else
        return [[_dataArray objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView != _tableView)
        return 1;
    else
        return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
    }
    if (tableView != _tableView) {
        cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
    }
    else
        cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.editingAccessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11111.png"]] autorelease];

    cell.imageView.image = [UIImage imageNamed:@"aa.png"];
    return cell;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated ];
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section %2 == 0)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [[_dataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSString * new = @"new Word!!";
        [[_dataArray objectAtIndex:indexPath.section] insertObject:new atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *mov = [[_dataArray objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    [[_dataArray objectAtIndex:sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    [[_dataArray objectAtIndex:destinationIndexPath.section] insertObject:mov atIndex:destinationIndexPath.row];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
