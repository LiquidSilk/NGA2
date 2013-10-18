//
//  SubscribeModel.m
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import "SubscribeModel.h"
#import "DataVO.h"

static SubscribeModel* _model;
@implementation SubscribeModel
+(SubscribeModel*)sharedModel
{
    if(_model == Nil)
    {
        _model = [[SubscribeModel alloc] init];
    }
    return _model;
}

-(SubscribeModel*)init
{
    self = [super init];
    observerList = [[NSMutableArray alloc] init];
    return  self;
}

-(void)pushObserver:(id<DataObserver>)observer
{
    //很变态，假如观察者数组内已存在要加入的观察者，直接无视
   if([observerList indexOfObject:observer] < [observerList count])
   {
       return;
   }
    [observerList addObject:observer];
}

-(void)removeObserver:(id)observer
{
    [observerList removeObject:observer];
}

-(void)subscribeData:(DataVO*)data
{
    int i=0;
    int __count = [observerList count];
    for(i=0; i<[observerList count]; i++)
    {
        id<DataObserver> __observer = (id<DataObserver>)[observerList objectAtIndex:i];
        [__observer receiveData:data];
    }
}
@end
