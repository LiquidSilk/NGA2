//
//  MasterViewController.m
//  NGA
//
//  Created by 陈 忠杰 on 13-10-16.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PostCell.h"
#import "MsgModel.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    [[SubscribeModel sharedModel] pushObserver:self];
    [[MsgModel sharedModel] sendMsg:1002 withUrl:@"/thread.php?fid=7&page=1&lite=js&noprefix"];
}

-(void)receiveData:(DataVO*)dataVO
{
    if (dataVO.module == 1002)
    {
        NSDictionary* dict = [[dataVO.data objectForKey:@"data"] objectForKey:@"__T"];
        arrayTList = [NSMutableArray arrayWithCapacity:1];
        [arrayTList retain];
            NSArray *keys;
            int i, count;
            id key, value;
            
            keys = [dict allKeys];
            count = [keys count];
            for (i = 0; i < count; i++)
            {
                key = [keys objectAtIndex: i];
                value = [dict objectForKey: key];
                [arrayTList addObject:value];
            }
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [[MsgModel sharedModel] login:1001 withName:@"chenzhongjie42@gmail.com" withPwd:@"cql1038204"];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayTList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell1" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"PostCell1"];
        

    }

    if (indexPath.row % 2 == 0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0xFF/255.0f  green:0xF8/255.0f blue:0xE5/255.0f alpha:0.5];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0xFE/255.0f  green:0xF3/255.0f blue:0xD1/255.0f alpha:0.5];
    }
    
    
    NSDictionary* dict = [arrayTList objectAtIndex:indexPath.row];
    NSString* title = [dict objectForKey:@"subject"];
    
    cell.title.text = title;
    NSLog(@"%d----%@", title.length,title);
    [cell setStyle:title];
    
//    //初始化label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//    //设置自动行数与字符换行
//    [label setNumberOfLines:3];
//    label.lineBreakMode = NSLineBreakByCharWrapping;
//    // 测试字串
//    NSString *s = title;
//    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
//    //设置一个行高上限
//    CGSize size = CGSizeMake(320,2000);
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping
//                        ];
//    [label setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
//    label.text = title;
//    [cell.contentView addSubview:label];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [arrayTList objectAtIndex:indexPath.row];
    NSString* title = [dict objectForKey:@"subject"];
    
    CGSize  size = [title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 25;
    if (title.length)
    {
        int nLine = floor(title.length / 20);
        return (nLine + 1) * 25;
    }
    else
    {
        return 0;
    }
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
