//
//  EventManager.h
//  test
//
//  Created by 陈 忠杰 on 13-9-18.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventManager : NSObject

@property(nonatomic,retain) NSString* eventId;
@property(nonatomic,retain) NSString* eventDetailId;

//new event
@property(nonatomic,assign) int classId;            //二级列表id
@property(nonatomic,retain) NSString* className;    //二级列表名称
@property(nonatomic,retain) NSString* desc;         //描述
@property(nonatomic,retain) NSString* eventName;    //事件名称
@property(nonatomic,retain) NSString* objectType;   //对象类型
@property(nonatomic,retain) NSDate* outRangeDate;   //过期时间
@property(atomic,retain) NSMutableArray* arrayOption;   //选项


@property(nonatomic,assign) bool showAddBtn;//是否是自定义事件
@property(nonatomic,assign) int topId;

+(EventManager*) sharedEventManager;
-(void)resetNewEvent;
@end
