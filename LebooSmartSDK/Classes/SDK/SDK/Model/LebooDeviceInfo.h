//
//  LebooDeviceInfo.h
//  LebooSDK
//
//  Created by lebong on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "LebooEnums.h"


@interface LebooDeviceInfo : NSObject

///刷牙时长（秒）
@property (nonatomic, assign) LebooBrushTime time;

///刷牙力度
@property (nonatomic, assign) LebooBrushForce force;

///模式
@property (nonatomic, assign) LebooBrushMode mode;

///子模式
@property (nonatomic, assign) LebooBrushChildMode childMode;

@end


