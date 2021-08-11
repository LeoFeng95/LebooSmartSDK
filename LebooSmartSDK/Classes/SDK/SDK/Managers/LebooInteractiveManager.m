//
//  LebooInteractiveManager.m
//  LebooSDK
//
//  Created by lebong on 2021/7/15.
//

#import "LebooInteractiveManager.h"
#import "LebooBLEManager.h"
#import "LebooSmartSDK.h"
#import "LebooBLEDecoder.h"


NSString *kBindResultKey = @"command_02";
NSString *kSetForceResultKey = @"command_0A";
NSString *kGetDeviceInfoResultKey = @"command_11";
//NSString *kResponseBindResult = @"comand_0x02";
//NSString *kResponseBindResult = @"comand_0x02";
//NSString *kResponseBindResult = @"comand_0x02";

@implementation LebooInteractiveManager


#pragma mark --- 指令交互--------

- (void)onBindDeviceComletion:(LebooArgsBlock)completion {
    
    self.commandDic[kBindResultKey] = completion;
    //01 00 01
    NSData *data = [LebooBLEDecoder convertHexStrToData:@"010102"];
    [[self bleM] writeData: data];
//    NSObject
}

- (void)onSetDeviceForce:(LebooBrushForce)force
               comletion:(LebooArgsBlock)completion {
    self.commandDic[kSetForceResultKey] = completion;
    Byte bytes[] = {};
    bytes[0] = 0x09;
    bytes[1] = 0x01;
    switch (force) {
        case LebooBrushForce_level1:
            bytes[2] = 0x00;
            break;
            
        case LebooBrushForce_level2:
            bytes[2] = 0x01;
            break;
            
        case LebooBrushForce_level3:
            bytes[2] = 0x02;
            break;
            
        case LebooBrushForce_level4:
            bytes[2] = 0x03;
            break;
            
        default:
            break;
    }
    bytes[3] = (bytes[0] + bytes[1] + bytes[2]) & 0xff;
    NSData *data = [NSData dataWithBytes:bytes length:4];
    [[self bleM] writeData: data];
}

- (void)onSetDeviceBrushTime:(LebooBrushTime)brushTime
                   comletion:(LebooArgsBlock)completion {

}

- (void)onGetDeviceInfoComletion:(LebooArgsBlock)completion {
    self.commandDic[kGetDeviceInfoResultKey] = completion;
    NSData *data = [LebooBLEDecoder convertHexStrToData:@"100011"];
    [[self bleM] writeData: data];
}

- (void)onGetDeviceBatteryComletion:(LebooArgsBlock)completion {
    NSData *data = [LebooBLEDecoder convertHexStrToData:@"010001"];
    [[self bleM] writeData: data];
}
- (void)onGetDeviceVersionComletion:(LebooArgsBlock)completion {
    
}

- (void)addDelegate:(id<LebooInstructDelegate>)delegate {

    
    
}



#pragma mark ---- 监听特征值变化------
- (void)OnNotifyCharacteristicData:(NSData *)data {
    
    if (data == nil) {
        [LebooLog log:@"未有设备连接"];
        return;
    }
    
    NSData *commandType = [data subdataWithRange:NSMakeRange(0, 1)];
    NSString *commandStr = [[commandType hexStr] uppercaseString];
    NSString *key = [NSString stringWithFormat:@"command_%@", commandStr];
    
    LebooArgsBlock block = self.commandDic[key];
    
    if ([key isEqualToString:kBindResultKey]) {
        //绑定结果
        NSString *errorCode = [[data subdataWithRange:NSMakeRange(2, 1)] hexStr];
        bool success = false;
        if ([errorCode isEqualToString:@"00"]) {
            success = true;
        } else {
            success = false;
        }
        block(@(success));
        [self.commandDic removeObjectForKey:key];
        
    } else if ([key isEqualToString:kGetDeviceInfoResultKey]) {
        
        
    } else if ([key isEqualToString:kSetForceResultKey]) {
        //设置刷牙力度结果
        NSString *errorCode = [[data subdataWithRange:NSMakeRange(2, 1)] hexStr];
        bool success = false;
        if ([errorCode isEqualToString:@"00"]) {
            success = true;
        } else {
            success = false;
        }
        block(@(success));
        [self.commandDic removeObjectForKey:key];
    }
    
    
}


- (LebooBLEManager *)bleM {
    LebooBLEManager *manager = (LebooBLEManager *)[LebooSmartSDK shareSDK].connectManager;
    return manager;
}


- (NSMutableDictionary *)commandDic {
    if (!_commandDic) {
        _commandDic = [NSMutableDictionary dictionary];
    }
    return _commandDic;
}

@end
