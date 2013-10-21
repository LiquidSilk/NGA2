//
//  PostCell.h
//  NGA
//
//  Created by 陈 忠杰 on 13-10-21.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell


@property (nonatomic, retain)IBOutlet UITextView *title;

-(void)setStyle:(NSString*)text;
@end
