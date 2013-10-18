//
//  MsgModel.m
//  Slime
//
//  Created by czj on 13-10-18.
//
//

#import "MsgModel.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

static MsgModel* _model;
static uint TIME_OUT = 30;
static NSString* serverName = @"http://bbs.ngacn.cc";

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

-(void)sendMsg:(uint)module withUrl:(NSString*)url
{
    NSMutableDictionary* __data = [[NSMutableDictionary alloc] init];
    NSString* strUrl = [NSString stringWithFormat:@"%@%@", serverName, url];
    [__data setValue:strUrl forKey:@"url"];
    [__data setValue:[[NSNumber alloc] initWithInt:module ]  forKey:@"module"];
    
    
    NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_handler_send:) object:__data];
    [msgQueue addOperation:op];
    [op release];
    
    NSLog(@"send.....");
}

-(void)login:(uint)module withName:(NSString*)name withPwd:(NSString*)pwd
{
    NSString* url = @"http://account.178.com/q_account.php?_act=login&type=username";
    NSURL* __url = [NSURL URLWithString:url];
    ASIFormDataRequest* __request = [ASIFormDataRequest requestWithURL:__url];
    [__request setShouldRedirect:NO];
    [__request setPostValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [__request setPostValue:@"GBK" forKey:@"Accept-Charset"];
    [__request setPostValue:@"AndroidNga/460" forKey:@"User-Agent"];
    [__request setPostValue:name forKey:@"email"];
    [__request setPostValue:pwd forKey:@"password"];
    
    NSLog(@"%@", [__request responseString]);
    [__request startSynchronous];
    int result = [__request responseStatusCode];
    if (result == 302)
    {
        NSDictionary* headers = [__request responseHeaders];
        [self parseHeader:headers];
    }
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
    ASIHTTPRequest* __request = [ASIHTTPRequest requestWithURL:__url];

    [__request addRequestHeader:@"User-Agent" value:@"AndroidNga/460"];
    [__request addRequestHeader:@"Cookie" value:@"GBK"];
    [__request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSString* cid = [[NSUserDefaults standardUserDefaults] valueForKey:@"cid"];
    NSString* uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString* cookie = [NSString stringWithFormat:@"ngaPassportUid=%@; ngaPassportCid=%@", uid, cid];
    [__request addRequestHeader:@"Cookie" value:cookie];
    [__request setTimeOutSeconds:TIME_OUT];
    __request.delegate = self;
    
//    //假如需要传递数据
//    if(data != Nil)
//    {
//        NSArray* __keys = [data allKeys];
//        int __itemCount = [data count];
//        int i=0;
//        //依次把数据全部写入到要POST的数据内
//        for(i=0; i<__itemCount; i++)
//        {
//            NSString* __key = (NSString*)[__keys objectAtIndex:i];
//            [__request setPostValue:[data objectForKey:__key] forKey:__key];
//        }
//    }
    
    //发送数据
    [__request startSynchronous];
    
    //解析从服务端返回的数据
    NSDictionary* __responseData = [self _readResponse2NSDictionary:__request];

    int __module = [[data objectForKey:@"module"] intValue];
    int __type = 0;//[(NSString*)[__responseData objectForKey:@"type"] intValue];
    NSDictionary * __data = __responseData;
    
    
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
-(NSData*)_readResponse:(ASIHTTPRequest*)request
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
-(NSString*)_readResponse2NSString:(ASIHTTPRequest*)request
{
    NSData * __data = [self _readResponse:request];
    NSString * __string = [[NSString alloc] initWithData:__data encoding:NSUTF8StringEncoding];
    return __string;
}

//将HTTP返回的数据读成NSDictionary类型
-(NSDictionary*)_readResponse2NSDictionary:(ASIHTTPRequest*)request
{
    NSData * __data = [self _readResponse:request];
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* _str = [[NSString alloc] initWithData:__data encoding:gbkEncoding];
    NSLog(@"服务端发来的数据：%@",_str);
    NSData* utfData = [_str dataUsingEncoding:NSUTF8StringEncoding];
    NSError* __error3 = nil;
    id __jsonData = [NSJSONSerialization JSONObjectWithData:utfData options:NSJSONReadingAllowFragments error:&__error3];
    if(__jsonData && __error3==nil)
    {
        if([__jsonData isKindOfClass:[NSDictionary class]])
        {
            return  (NSDictionary *)__jsonData;
        }
    }
    return Nil;
}

-(void)parseHeader:(NSDictionary*)header
{
    NSString* strCookie = [header objectForKey:@"Set-Cookie"];
    NSArray* arrayCookie = [strCookie componentsSeparatedByString:@";"];
    
    NSString* cid;
    NSString* uid;
    for (int i = 0; i < arrayCookie.count; i ++)
    {
        NSString* strTmp = [arrayCookie objectAtIndex:i];
        NSString* keyCid = @"_sid=";
        NSRange range1 = [strTmp rangeOfString:keyCid];
        if (range1.length)
        {
            cid = [strTmp substringFromIndex:range1.location + range1.length];
        }
        
        NSString* keyUid = @"_178c=";
        NSRange range2 = [strTmp rangeOfString:keyUid];
        if (range2.length)
        {
            uid = [strTmp substringFromIndex:range2.location + range2.length];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:cid forKey:@"cid"];
    [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
}
@end
