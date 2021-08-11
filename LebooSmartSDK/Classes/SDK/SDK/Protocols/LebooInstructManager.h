//
//  LebooInstructManager.h
//  LebooSDK
//
//  Created by lebong on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <LebooSDK/LebooEnums.h>


typedef void (^LebooArgsBlock)(id obj);


@protocol LebooInstructDelegate <NSObject>




@end


@protocol LebooInstructManager <NSObject>

@optional

- (void)onBindDeviceComletion:(LebooArgsBlock)completion;


- (void)onSetDeviceMode:(LebooBrushMode)mode
             completion:(LebooArgsBlock)completion;

- (void)onSetDeviceForce:(LebooBrushForce)force
               comletion:(LebooArgsBlock)completion;



- (void)onSetDeviceBrushTime:(LebooBrushTime)brushTime
                   comletion:(LebooArgsBlock)completion;

- (void)onGetDeviceInfoComletion:(LebooArgsBlock)completion;
- (void)onGetDeviceBatteryComletion:(LebooArgsBlock)completion;
- (void)onGetDeviceVersionComletion:(LebooArgsBlock)completion;


///添加代理
- (void)addDelegate:(id<LebooInstructDelegate>)delegate;
@end

