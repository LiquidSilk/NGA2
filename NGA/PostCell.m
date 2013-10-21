//
//  PostCell.m
//  NGA
//
//  Created by 陈 忠杰 on 13-10-21.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setStyle:(NSString*)text
{
    _title.editable = NO;
    _title.userInteractionEnabled = NO;
    _title.font = [UIFont systemFontOfSize:14];
    _title.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:_title];
    
//    CGSize  size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:NSLineBreakByWordWrapping];

    int height = 0;
    if (text.length)
    {
        int nLine = floor(text.length / 20);
        height = nLine + 1;
    }
    //_title.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGRect rect = _title.frame;
    [_title setFrame:CGRectMake(0, 0, 300, height * 18 + 16)];
    [_title setText:text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}
@end
