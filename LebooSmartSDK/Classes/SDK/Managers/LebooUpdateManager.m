//
//  LebooUpdateManager.m
//  LebooSDK
//
//  Created by lebong on 2021/7/19.
//

#import "LebooUpdateManager.h"
#import "LebooBLEManager.h"
#import "LebooSmartSDK.h"
//#import <iOSDFULibrary-Swift.h>


//@interface LebooUpdateManager ()<DFUServiceDelegate, DFUProgressDelegate>
//
//@property (nonatomic, weak) id<LebooUpgradeDelegate>delegate;
//
//@property (nonatomic, strong) DFUServiceController *serviceController;
//
//@end

@implementation LebooUpdateManager





//- (void)upgradeDeviceWithFile:(NSURL *)fileUrl delegate:(id<LebooUpgradeDelegate>)delegate {
//    
//    self.delegate = delegate;
//    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:fileUrl];// or
//  
//    CBPeripheral *device = [self bleManager].connectDevice;
//    if (device == nil) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(devcieUpgradeFailedWithMessage:)]) {
//            [self.delegate devcieUpgradeFailedWithMessage:@"未有连接的设备"];
//        }
//        return;
//    }
//    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:dispatch_get_main_queue() delegateQueue:dispatch_get_main_queue() progressQueue:dispatch_get_main_queue() loggerQueue:dispatch_get_main_queue()];
//
//    initiator.packetReceiptNotificationParameter = 20;
//    initiator.delegate = self; // - to be informed about current state and errors
//    initiator.progressDelegate = self; // - to show progress bar
//    initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true;
//
//    
//    initiator = [initiator withFirmware:selectedFirmware];
//
//    self.serviceController = [initiator startWithTarget:device];
//
//}
//
//- (void)dfuStateDidChangeTo:(enum DFUState)state {
//   
//    switch (state) {
//        case DFUStateCompleted: {
//            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(deviceUpgradeSuccessfully)]) {
//                [self.delegate deviceUpgradeSuccessfully];
//                [LebooLog log:@"升级成功"];
//            }
//        }
//            
//            break;
//            
//        default: {
////            if (self.delegate && [self.delegate respondsToSelector:@selector(devcieUpgradeFailedWithMessage:)]) {
////                [self.delegate devcieUpgradeFailedWithMessage:@"升级失败"];
////            }
//        }
//            break;
//    }
//    
//}
//
//- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(devcieUpgradeFailedWithMessage:)]) {
//        [self.delegate devcieUpgradeFailedWithMessage:message];
//    }
//}
//
//
//
//- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(upgradeManagerDidChangeProgress:currentSpeedBytesPerSecond:)]) {
//        [self.delegate upgradeManagerDidChangeProgress:progress / 100.0 currentSpeedBytesPerSecond:currentSpeedBytesPerSecond];
//    }
//}
//
//
//
//
//- (LebooBLEManager *)bleManager {
//    LebooBLEManager *manager = [LebooSmartSDK shareSDK].connectManager;
//    return manager;
//}

@end
