//
//  ConfigUtil.m
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import "ConfigUtil.h"

static ConfigUtil* _model;

@implementation ConfigUtil

+(ConfigUtil*)sharedConfigUtil
{
    if(_model == Nil)
    {
        _model = [[ConfigUtil alloc] init];
    }
    return _model;
}

-(NSString*)getUserName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Param" ofType:@"plist"];
    NSDictionary* _dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [_dic objectForKey:@"userName"];
}

@end
