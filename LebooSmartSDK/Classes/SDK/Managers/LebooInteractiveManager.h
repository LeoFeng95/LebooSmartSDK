//
//  LebooInteractiveManager.h
//  LebooSDK
//
//  Created by lebong on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "LebooInstructManager.h"


@interface LebooInteractiveManager : NSObject<LebooInstructManager>


///命令缓存池 key: 命令key, value: 命令对应返回的block
@property (nonatomic, strong) NSMutableDictionary *commandDic;



///特征值变化
- (void)OnNotifyCharacteristicData:(NSData *)data;







@end


