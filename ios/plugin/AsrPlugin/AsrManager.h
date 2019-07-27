//
//  NSObject+AsrManager.h
//  Runner
//
//  Created by Ying Wang on 2019/7/27.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsrManager:NSObject
typedef void(^AsrCallback)(NSString* message);
+(instancetype) initWith:(AsrCallback)success failure:(AsrCallback)failure;
-(void)start;
-(void)stop;
-(void)cancel;
@end
