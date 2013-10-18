//
//  DataVO.m
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import "DataVO.h"

@implementation DataVO
-(DataVO*)initData:(NSDictionary *)data withModule:(int)module withType:(int)type
{
    self = [super init];
    self.module = module;
    self.type = type;
    self.data = data;
    return self;
}
@end
