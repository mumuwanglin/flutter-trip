//
//  AsrManager.h
//  Runner
//
//  Created by 王林 on 2019/11/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AsrCallback) (NSString *message);

@interface AsrManager : NSObject
+ (instancetype) initWith:(AsrCallback)success failure:(AsrCallback)failure;
- (void)start;
- (void)stop;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
