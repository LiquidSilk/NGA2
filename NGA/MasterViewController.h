//
//  MasterViewController.h
//  NGA
//
//  Created by 陈 忠杰 on 13-10-16.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSMutableArray* arrayTList;
}
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
