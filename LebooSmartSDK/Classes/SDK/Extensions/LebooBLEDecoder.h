//
//  LebooBLEDecoder.h
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LebooBLEDecoder : NSObject

+ (NSString *)decoderMacWithData:(NSData *)data;

+ (NSString *)hexStringFromData:(NSData *)myD;

+ (NSString *)getManufacture:(NSString *)str;

+ (NSData *)convertHexStrToData:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
