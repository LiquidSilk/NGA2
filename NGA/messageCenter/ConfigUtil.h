//
//  ConfigUtil.h
//  Slime
//
//  Created by dominic tung on 13-4-3.
//
//

#import <Foundation/Foundation.h>


@interface ConfigUtil : NSObject
{
}

+(ConfigUtil*) sharedConfigUtil;

-(NSString*)getUserName;

@end
