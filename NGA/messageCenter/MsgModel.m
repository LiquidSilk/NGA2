//
//  MsgModel.m
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import "MsgModel.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

static MsgModel* _model;
static uint TIME_OUT = 30;
static NSString* serverName = @"http://183.129.175.36:7184";

@implementation MsgModel

+(MsgModel*)sharedModel
{
    if(_model == Nil)
    {
        _model = [[MsgModel alloc] init];
    }
    return _model;
}

+(NSString*)packMessage:(NSMutableDictionary*)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if(error)
    {
        NSLog(@"it is bad message");
        return nil;
    }
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * __result = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [json release];
    return [__result autorelease];
}

-(MsgModel*)init
{
    self = [super init];
    msgQueue = [[NSOperationQueue alloc] init];
    msgQueue.maxConcurrentOperationCount = 1;
    return  self;
}

-(void)sendMsg:(uint)module withData:(NSMutableDictionary*)data;
{
    NSMutableDictionary* __data = [[NSMutableDictionary alloc] init];
    [__data setValue:serverName forKey:@"url"];
    [__data setValue:[[NSNumber alloc] initWithInt:module ]  forKey:@"module"];

    [__data setValue:[[NSMutableDictionary alloc] initWithDictionary:data] forKey:@"data"];
    
    NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_handler_send:) object:__data];
    [msgQueue addOperation:op];
    [op release];

    NSLog(@"send.....");

}

-(void)_handler_send:(NSMutableDictionary*)data
{
    NSLog(@"收到url....");
    NSString * __url = (NSString*)[data objectForKey:@"url"];
    NSNumber * __module = (NSNumber*)[data objectForKey:@"module"];
    NSMutableDictionary * __data = [[NSMutableDictionary alloc] initWithDictionary:[data objectForKey:@"data"] copyItems:NO];
    NSString * __str = [MsgModel packMessage:__data];
    [__data setValue:__module forKey:@"module"];
    
    [__data setValue:__str forKey:@"para"];
    NSLog(@"我发出的数据：%@",__data);
    [self _sendHttpRequest:__url withData:__data];
}

-(void)_sendHttpRequest:(NSString*)url withData:(NSMutableDictionary*)data
{
    NSLog(@"url:%@",url);
    NSURL* __url = [NSURL URLWithString:url];
    ASIFormDataRequest* __request = [ASIFormDataRequest requestWithURL:__url];
    [__request setTimeOutSeconds:TIME_OUT];
    __request.delegate = self;
    
    //假如需要传递数据
    if(data != Nil)
    {
        NSArray* __keys = [data allKeys];
        int __itemCount = [data count];
        int i=0;
        //依次把数据全部写入到要POST的数据内
        for(i=0; i<__itemCount; i++)
        {
            NSString* __key = (NSString*)[__keys objectAtIndex:i];
            [__request setPostValue:[data objectForKey:__key] forKey:__key];
        }
    }
    
    //发送数据
    [__request startSynchronous];
    
    NSString * __str = [self _readResponse2NSString:__request];
    NSLog(@"服务端发来的数据：%@",__str);
    
    //解析从服务端返回的数据
    NSDictionary* __responseData = [self _readResponse2NSDictionary:__request];

    int __module = [(NSString*)[__responseData objectForKey:@"module"] intValue];
    int __type = [(NSString*)[__responseData objectForKey:@"type"] intValue];
    NSDictionary * __data = (NSDictionary *)[__responseData objectForKey:@"para"];
    
    
    //获取协议号，所有观察者根据协议号来处理数据逻辑
    
    DataVO * __dataVo = [[DataVO alloc] initData:__data withModule:__module withType:__type];
    
    [self performSelectorOnMainThread:@selector(subscriberData:) withObject:__dataVo waitUntilDone:NO];
    
//    NSString * __data = [self _readResponse2NSString:__request];
//    NSLog(@"data from server:");
//    NSLog(@"%@",__data);
}

-(void)subscriberData:(DataVO*)data
{
    //将数据分发出去
    [[SubscribeModel sharedModel] subscribeData:data];
}

//该方法用来解析从服务端返回来的数据
-(NSData*)_readResponse:(ASIFormDataRequest*)request
{
    NSError * __error = [request error];
    if(!__error)
    {
        NSData * __responseData = [request responseData];
        
        return __responseData;
    }
    return Nil;
}

//将HTTP返回的数据读成NSString类型
-(NSString*)_readResponse2NSString:(ASIFormDataRequest*)request
{
    NSData * __data = [self _readResponse:request];
    NSString * __string = [[NSString alloc] initWithData:__data encoding:NSUTF8StringEncoding];
    return __string;
}

//将HTTP返回的数据读成NSDictionary类型
-(NSDictionary*)_readResponse2NSDictionary:(ASIFormDataRequest*)request
{
    NSData * __data = [self _readResponse:request];
    NSError* __error3 = nil;
    id __jsonData = [NSJSONSerialization JSONObjectWithData:__data options:NSJSONReadingAllowFragments error:&__error3];
    if(__jsonData && __error3==nil)
    {
        if([__jsonData isKindOfClass:[NSDictionary class]])
        {
            return  (NSDictionary *)__jsonData;
        }
    }
    return Nil;
}
@end
