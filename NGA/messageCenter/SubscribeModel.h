//
//  SubscribeModel.h
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import <Foundation/Foundation.h>
#import "DataVO.h"

@protocol DataObserver
-(void)receiveData:(DataVO*)data;
@end

@interface SubscribeModel : NSObject
{
    //保存所有观察者的数组
    NSMutableArray * observerList;
}
+(SubscribeModel*) sharedModel;

-(void)pushObserver:(id<DataObserver>)observer;
-(void)removeObserver:(id)observer;

-(void)subscribeData:(DataVO*)data;
@end
