//
//  LebooLog.h
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LebooLog : NSObject



//控制台打印
+ (void)log:(NSString *)info, ...;

//打印到文件日志
+ (void)logToFile:(NSString *)info, ...;


//控制台和日志文件都打印
+ (void)logAll:(NSString *)info, ...;

@end

NS_ASSUME_NONNULL_END
