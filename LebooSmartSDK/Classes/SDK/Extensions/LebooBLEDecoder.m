//
//  LebooBLEDecoder.m
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import "LebooBLEDecoder.h"

@implementation LebooBLEDecoder

+ (NSString *)decoderMacWithData:(NSData *)data {
    
    NSMutableString *macStr = [NSMutableString string];
    if (data.length >= 6) {
        data = [data subdataWithRange:NSMakeRange(2, data.length - 2)];
        Byte *bytes = (Byte *)data.bytes;
        for (NSInteger i = data.length - 1; i >= 0; i--) {
            NSString *hexStr = [NSString stringWithFormat:@"%02X", bytes[i] & 0xff];
            if (i == 0) {
                [macStr appendString:hexStr];
            } else {
                [macStr appendFormat:@"%@:", hexStr];
            }
         
        }
    }
    return macStr.copy;
}

+ (NSString *)hexStringFromData:(NSData *)myD {
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",bytes[i]&0xff];///16进制数
        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}

+ (NSString *)getManufacture:(NSString *)str {
    if (str.length >= 12) {
        NSString *str1 = [str substringFromIndex:str.length-2].uppercaseString;
        NSString *str2 = [str substringWithRange:NSMakeRange(str.length-4, 2)].uppercaseString;
        NSString *str3 = [str substringWithRange:NSMakeRange(str.length-6, 2)].uppercaseString;
        NSString *str4 = [str substringWithRange:NSMakeRange(str.length-8, 2)].uppercaseString;
        NSString *str5 = [str substringWithRange:NSMakeRange(str.length-10, 2)].uppercaseString;
        NSString *str6 = [str substringWithRange:NSMakeRange(str.length-12, 2)].uppercaseString;
        
        return [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",str1,str2,str3,str4,str5,str6];
        
    }else{
        
        return @"";
    }
    
}

/**
 把十六进制字符串转化为data

 @param str 十六进制字符串
 @return 转换后的data
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}


@end
