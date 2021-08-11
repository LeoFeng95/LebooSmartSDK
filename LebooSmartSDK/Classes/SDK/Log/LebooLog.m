//
//  LebooLog.m
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import "LebooLog.h"
#import "LebooSmartSDK.h"

@implementation LebooLog


+ (NSString *)logPath {
    
    //获取Document
    NSString *homeDirectory = NSHomeDirectory();
    NSString *sdkDirectory = [homeDirectory stringByAppendingPathComponent:@"Documents/LebooSDK"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    if (![fileM fileExistsAtPath:sdkDirectory]) {
       [fileM createDirectoryAtPath:sdkDirectory withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *logPath = [sdkDirectory stringByAppendingPathComponent:@"leboo.log"];
    return logPath;
}

+ (void)log:(NSString *)info, ... {
    va_list paramList;
    va_start(paramList, info);
    NSString* log = [[NSString alloc]initWithFormat:info arguments:paramList];
    va_end(paramList);
    if ([[LebooSmartSDK shareSDK] enableLogging]) {
        NSLog(@"%@",log);
    }
  
}

+ (void)logToFile:(NSString *)info, ... {
    va_list paramList;
    va_start(paramList, info);
    NSString* log = [[NSString alloc]initWithFormat:info arguments:paramList];
    NSString* logToStore = [log stringByAppendingString:@"\n"];
    va_end(paramList);

    NSString* logPath = [self logPath];
    [logToStore writeToFile:logPath atomically:true encoding:NSUTF8StringEncoding error:nil];
}


+ (void)logAll:(NSString *)info, ... {
    va_list paramList;
    va_start(paramList, info);
    NSString* log = [[NSString alloc]initWithFormat:info arguments:paramList];
    NSString* logToStore = [log stringByAppendingString:@"\n"];
    va_end(paramList);
    NSString* logPath = [self logPath];
    [logToStore writeToFile:logPath atomically:true encoding:NSUTF8StringEncoding error:nil];

    if ([[LebooSmartSDK shareSDK] enableLogging]) {
        NSLog(@"%@",log);
    }
}


@end
