//
//  MsgModel.h
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import <Foundation/Foundation.h>
#import "DataVO.h"
#import "SubscribeModel.h"


@interface MsgModel : NSObject
{
    NSOperationQueue* msgQueue;
}

+(MsgModel*) sharedModel;

-(void)sendMsg:(uint)module withData:(NSDictionary*)data;

@end
