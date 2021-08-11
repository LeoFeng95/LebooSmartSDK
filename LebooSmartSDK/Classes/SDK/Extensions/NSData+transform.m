//
//  NSData+transform.m
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import "NSData+transform.h"

@implementation NSData (transform)


- (NSString *)hexStr {
    
    Byte *bytes = (Byte *)self.bytes;
    NSMutableString *hex = [NSMutableString string];
    for (int i = 0; i < self.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    
    return hex.copy;
}


@end

