//
//  EventManager.m
//  test
//
//  Created by 陈 忠杰 on 13-9-18.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

static EventManager* _model;

+(EventManager*)sharedEventManager
{
    if(_model == Nil)
    {
        _model = [[EventManager alloc] init];
    }
    return _model;
}

-(void)resetNewEvent
{
    self.desc = @"";
    self.eventName = @"";
    self.outRangeDate = nil;
    self.classId = 0;
    self.className = @"";
    [self.arrayOption removeAllObjects];
}
@end
