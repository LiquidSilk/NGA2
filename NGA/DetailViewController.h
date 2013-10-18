//
//  DetailViewController.h
//  NGA
//
//  Created by 陈 忠杰 on 13-10-16.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
