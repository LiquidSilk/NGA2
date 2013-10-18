//
//  DataVO.h
//  Slime
//  接收从服务端传来的数据类型基类
//
//  Created by dominic tung on 13-4-3.
//
//

#import <Foundation/Foundation.h>

@interface DataVO : NSObject
//协议号
@property(nonatomic,assign) int module;
@property(nonatomic,assign) int type;

@property(nonatomic,retain) NSDictionary* data;

//初始化数据的方法
-(DataVO*)initData:(NSDictionary *)data withModule:(int)module withType:(int)type;
@end
