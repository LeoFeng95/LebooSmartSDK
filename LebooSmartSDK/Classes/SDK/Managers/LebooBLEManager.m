//
//  LebooSearchManager.m
//  LebooSDK
//
//  Created by lebong on 2021/7/12.
//

#import "LebooBLEManager.h"
#import "LebooBLEDecoder.h"
#import "LebooSmartSDK.h"
#import "LebooInteractiveManager.h"
#import <LebooSmartSDK/LebooSDKConst.h>
@interface LebooBLEManager ()
<CBCentralManagerDelegate,
CBPeripheralDelegate>


///中心设备管理者
@property (nonatomic, strong) CBCentralManager *centralM;

///扫描完成
@property (nonatomic, copy) LebooSearchBlock searchCompletion;

///连接完成
@property (nonatomic, copy) LebooConnectionBlock connectionBlock;

///断开连接
@property (nonatomic, copy) LebooDisconnectBlock disConnectBlock;

///当前的连接蓝牙对象
@property (nonatomic, strong) CBPeripheral *currentDevice;

///写入特征
@property (nonatomic, strong) CBCharacteristic *wCharacteristic;

///订阅特征
@property (nonatomic, strong) CBCharacteristic *notiCharacteristic;

///特征值数量
@property (nonatomic, assign) NSInteger characteristicNumber;

///代理数组
@property (nonatomic, copy) NSPointerArray *delegateArr;

@end

@implementation LebooBLEManager {
    
    //各种超时处理
    NSTimer *_timeoutTimer;
    //超时时间
    NSTimeInterval _timeout;
    //当前连接对象信息
    LebooPeripheral *_deviceInfo;
    //当前设备的mac地址
    NSString *_macStr;

}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self centralM];
    }
    return self;
}


#pragma mark ---------扫描----------
//开始扫描
- (void)startSearchDevice:(NSTimeInterval)timeInterval
               completion:(LebooSearchBlock)completion {
    self.searchCompletion = completion;
    [self releaseTimer];
    if (self.centralM.state == CBManagerStatePoweredOn) {
        NSArray *services = @[[CBUUID UUIDWithString:@"0000FFB0-0000-1000-8000-00805F9B34FB"],[CBUUID UUIDWithString:@"FFB0"],[CBUUID UUIDWithString:@"FE59"]];
        [self.centralM scanForPeripheralsWithServices:services options:nil];
        
        //超时处理
        _timeout = timeInterval;
        _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:true];
    } else {
    
        if (self.searchCompletion) {
            NSError *error = [NSError errorWithDomain:@"蓝牙未打开或者未授权" code:-2 userInfo:nil];
            self.searchCompletion(nil, error);
        }
    }
    
}

//停止扫描
- (void)stopScan {
    if (self.centralM.isScanning) {
        [self.centralM stopScan];
    }
}







#pragma mark ---------连接----------

/// 连接设备
/// @param peripheral 设备对象
/// @param time 超时时间
/// @param completion 连接完成 error为nil为连接成功
//- (void)connectPeriphral:(LebooPeripheral *)peripheral
//                 timeout:(NSTimeInterval)time
//              completion:(LebooConnectionBlock)completion {
//
//    //断开当前设备的连接
//    if (self.currentDevice) {
//        [self.centralM cancelPeripheralConnection:self.currentDevice];
//    }
//    if (self.centralM.isScanning) {
//        [self.centralM stopScan];
//    }
//
//    self.disConnectBlock = nil;
//    self.connectionBlock = completion;
//    _deviceInfo = peripheral;
//    [self releaseTimer];
//
//
//
//    [self.centralM connectPeripheral:_deviceInfo.device options:nil];
//
//    //超时处理
//    _timeout = time;
//    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connectionTimeout) userInfo:nil repeats:true];
//
//}

/// 通过蓝牙设备的UUID连接
/// @param identifier 蓝牙设备的唯一标识
/// @param completion error为空的时候连接成功
//- (void)connnectWithPeripheralIdentifier:(NSString *)identifier
//                                 timeout:(NSTimeInterval)timeout
//                               comletion:(LebooConnectionBlock)completion {
//
//    //断开当前设备的连接
//    if (self.currentDevice) {
//        [self.centralM cancelPeripheralConnection:self.currentDevice];
//    }
//    if (self.centralM.isScanning) {
//        [self.centralM stopScan];
//    }
//    self.disConnectBlock = nil;
//    self.connectionBlock = completion;
//    [self releaseTimer];
//
//    if (self.centralM.state == CBManagerStatePoweredOn) {
//
//        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:identifier];
//        CBPeripheral *device = [self.centralM retrievePeripheralsWithIdentifiers:@[uuid]].lastObject;
//
//        if (device) {
//            //断开当前设备的连接
//            if (self.currentDevice) {
//                [self.centralM cancelPeripheralConnection:self.currentDevice];
//            }
//            //开始连接
//            [self.centralM connectPeripheral:device options:nil];
//
//            _timeout = timeout;
//            _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connectionTimeout) userInfo:nil repeats:true];
//
//        } else {
//            //未找到该设备
//            NSError *error = [NSError errorWithDomain:@"未找到对应设备" code:-2 userInfo:nil];
//            if (completion) {
//                completion(error);
//            }
//        }
//
//    } else {
//        NSError *error = [NSError errorWithDomain:@"蓝牙未打开或者未授权" code:-2 userInfo:nil];
//        if (completion) {
//            completion(error);
//        }
//    }
//}

//通过设备mac地址连接
- (void)connectPeriphralWithMac:(NSString *)mac
                        timeout:(NSTimeInterval)time
                     completion:(LebooConnectionBlock)completion {
    self.searchCompletion = nil;
    self.disConnectBlock = nil;
    self.connectionBlock = completion;
    [LebooLog log:@"设备开始连接mac地址-----%@", mac];
    _macStr = mac.copy;
    [self releaseTimer];
    if (self.centralM.state == CBManagerStatePoweredOn) {
        //断开之前设备的连接
        if (self.currentDevice) {
            [self.centralM cancelPeripheralConnection:self.currentDevice];
        }
        //开始扫描
        NSArray *services = @[[CBUUID UUIDWithString:@"FFB0"],[CBUUID UUIDWithString:@"FE59"]];
        [self.centralM scanForPeripheralsWithServices:services options:nil];
        
        //超时处理
        _timeout = time;
        _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connectionTimeout) userInfo:nil repeats:true];
    } else {
    
        if (self.connectionBlock) {
            NSError *error = [NSError errorWithDomain:@"蓝牙未打开或者未授权" code:-2 userInfo:nil];
            self.connectionBlock(error);
        }
    }
    
}

- (void)disConnectCompletion:(LebooDisconnectBlock)completion {
    self.disConnectBlock = completion;
    if (self.currentDevice) {
        [self.centralM cancelPeripheralConnection:self.currentDevice];
    } else {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"设备不存在" code:10 userInfo:nil];
            completion(error);
        }
    }
}





//连接超时处理
- (void)connectionTimeout {
    if (_timeout <= 0) {
        NSError *error;
        if (self.currentDevice) {
            error = [NSError errorWithDomain:@"连接超时" code:-1 userInfo:nil];
            [self.centralM cancelPeripheralConnection:self.currentDevice];
        } else  {
            error = [NSError errorWithDomain:@"设备不存在" code:-1 userInfo:nil];
        }
        
        [self stopScan];
        [self releaseTimer];
        
        if (self.connectionBlock) {
            self.connectionBlock(error);
        }
    
    }
    
    _timeout -= 1;
}

//扫描超时处理
- (void)timerStart {

    if (_timeout <= 0) {
        [self stopScan];
        [self releaseTimer];
        if (self.searchCompletion) {
            NSError *error = [NSError errorWithDomain:@"扫描完成" code:-2 userInfo:nil];
            self.searchCompletion(nil, error);
        }
        
    }
    _timeout -= 1;
}

//释放timer
- (void)releaseTimer {
    if (_timeoutTimer != nil) {
        [_timeoutTimer invalidate];
        _timeoutTimer = nil;
    }
}


//重设外设
- (void)resetPeripheral {
    self.wCharacteristic = nil;
    self.notiCharacteristic = nil;
    _deviceInfo = nil;
    _macStr = nil;
    self.currentDevice = nil;
    self.connectionBlock = nil;
}


#pragma mark -- 添加代理------
- (void)addDelegate:(id<LebooBLEDelegate>)delegate {
    [self.delegateArr addPointer:(__bridge void * _Nullable)(delegate)];
}

//写入指令
- (void)writeData:(NSData *)data {
    if (self.currentDevice) {
        [self.currentDevice writeValue:data forCharacteristic:self.wCharacteristic type:CBCharacteristicWriteWithoutResponse];
    } else {
        LebooInteractiveManager *manager = (LebooInteractiveManager *)[LebooSmartSDK shareSDK].instructManager;
        [manager OnNotifyCharacteristicData:nil];
    }
}


#pragma mark - CBCentralManagerDelegate（中心设备代理）
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        
        [LebooLog log:@"蓝牙打开了"];
        
    } else {
        
        [self resetPeripheral];
        [LebooLog log:@"蓝牙断开了"];
    }
    
    
    //代理转发 断开连接
    for (id<LebooBLEDelegate>obj in self.delegateArr) {
        if ([obj respondsToSelector:@selector(onChangeState:)]) {
            [obj onChangeState:central.state];
        }
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSString *name = advertisementData[@"kCBAdvDataLocalName"];
    if ([[LebooSmartSDK shareSDK].supportDevices containsObject:name]) {
        
        //解析mac地址
        NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
        NSString *macStr = @"";
        if (data && data.length == 8) {
            macStr = [LebooBLEDecoder decoderMacWithData:data];
        }
   
        [LebooLog log:@"mac地址...... %@", macStr];
        if ([_macStr isEqualToString:macStr]) {
            //找到mac地址了就连接
            _deviceInfo = [[LebooPeripheral alloc] init];
            _deviceInfo.name = name;
            _deviceInfo.mac = macStr;
            _deviceInfo.rssi = RSSI;
            [self.centralM stopScan];
            self.currentDevice = peripheral;
            [self.centralM connectPeripheral:peripheral options:nil];
        }
        
        if (self.searchCompletion) {
            //数据源
            LebooPeripheral *model = [[LebooPeripheral alloc] init];
            model.mac = macStr;
            model.rssi = RSSI;
            model.name = name;
            self.searchCompletion(model, nil);
        }
    }


}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.currentDevice = peripheral;
    self.currentDevice.delegate = self;
    [LebooLog log:@"设备连接成功--------发现服务"];
    [self.currentDevice discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.currentDevice = nil;
    if (self.connectionBlock) {
        [LebooLog log:@"设备连接失败----%@", error];
        self.connectionBlock(error);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    //代理转发 断开连接
    for (id<LebooBLEDelegate>obj in self.delegateArr) {
        if ([obj respondsToSelector:@selector(onDisconnect:error:)]) {
            [obj onDisconnect:_deviceInfo error:error];
        }
    }
    
    if (self.disConnectBlock) {
        self.disConnectBlock(nil);
    }
    if (self.currentDevice) {
        [self resetPeripheral];
    }
  
    [LebooLog log:@"%@ -- %@-- 设备断开连接 %@", peripheral.name, peripheral.name, _deviceInfo.mac];
}



#pragma mark - CBPeripheralDelegate（外设代理）
//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {

    for (CBService *service in peripheral.services) {
        //发现了我们要的服务,就去查找特征
        if ([service.UUID.UUIDString isEqualToString:@"0000FFB0-0000-1000-8000-00805F9B34FB"] || [service.UUID.UUIDString isEqualToString:@"FFB0"]) {
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
    
    for (CBService *service in peripheral.services) {
        //该服务是为了dfu的
        if ([service.UUID.UUIDString isEqualToString:@"FE59"]) {
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
}

//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
   
    if ([service.UUID.UUIDString isEqualToString:@"FFB0"]) {
        //读写数据服务
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqualToString:@"FFB1"]) {
                //指令写入
                self.wCharacteristic = characteristic;
            } else {
                //FFB2 订阅
                self.notiCharacteristic = characteristic;
                [peripheral setNotifyValue:true forCharacteristic:characteristic];
            }
        }
        //关闭定时器
        [self releaseTimer];
        if (self.wCharacteristic && self.notiCharacteristic) {
            if (self.connectionBlock) {
                self.connectionBlock(nil);
            }
        } else {
            if (self.connectionBlock) {
                NSError *error = [NSError errorWithDomain:@"设备连接失败，设备特征值不完整" code:-1 userInfo:nil];
                [LebooLog log:@"设备的读或者写特征值不完整"];
                self.connectionBlock(error);
                
            }
        }
        
        
    } else if ([service.UUID.UUIDString isEqualToString:@"FE59"]) {
        //DFU升级服务
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqualToString:@"8EC90001-F315-4F60-9FB8-838830DAEA50"] ||
                [characteristic.UUID.UUIDString isEqualToString:@"8EC90002-F315-4F60-9FB8-838830DAEA50"] ) {
                self.characteristicNumber += 1;
            } else {
                //9003
                return;
            }
        }
        //关闭定时器
        [self releaseTimer];
        if (self.characteristicNumber == 2) {
            self.characteristicNumber = 0;
            if (self.connectionBlock) {
                self.connectionBlock(nil);
            }
        } else {
            if (self.connectionBlock) {
                NSError *error = [NSError errorWithDomain:@"设备不支持升级" code:-300 userInfo:nil];
                self.connectionBlock(error);
            }
        }
    }
    
    
    
    
//
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString isEqualToString:@"0000FFB1-0000-1000-8000-00805F9B34FB"] || [characteristic.UUID.UUIDString isEqualToString:@"FFB1"]) {
//            self.characteristicNumber += 1;
//            self.wCharacteristic = characteristic;
//            [LebooLog log:@"%@---- 设备获取写入特征成功------ %@", peripheral.name,_deviceInfo.mac];
//            break;
//        }
//    }
//
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString isEqualToString:@"0000FFB2-0000-1000-8000-00805F9B34FB"] || [characteristic.UUID.UUIDString isEqualToString:@"FFB2"]) {
//            self.characteristicNumber += 1;
//            self.notiCharacteristic = characteristic;
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//
//            [LebooLog log:@"%@----设备获取订阅特征成功------ %@", peripheral.name, _deviceInfo.mac];
//            break;
//        }
//    }
//
//
//    //以下两个特征是设备进入dfu模式才有的,与上面的不会同时存在
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString isEqualToString:@"8EC90001-F315-4F60-9FB8-838830DAEA50"]) {
//            self.characteristicNumber += 1;
//            break;
//        }
//    }
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString isEqualToString:@"8EC90002-F315-4F60-9FB8-838830DAEA50"]) {
//            self.characteristicNumber += 1;
//            break;
//        }
//    }
    

}


//蓝牙数据传回来
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    //收到订阅值
    LebooInteractiveManager *manager = (LebooInteractiveManager *)[LebooSmartSDK shareSDK].instructManager;
    [manager OnNotifyCharacteristicData:characteristic.value];
}



#pragma mark -- setter and getter

- (CBManagerState)state {
    
    return self.centralM.state;
}

- (CBPeripheral *)connectDevice {
    return self.currentDevice;
}

- (CBCentralManager *)deviceManager {
    return self.centralM;
}

- (LebooPeripheral *)peripheralInfo {
    
    return _deviceInfo;
}



- (CBCentralManager *)centralM {
    if (!_centralM) {
        _centralM = [[CBCentralManager alloc] initWithDelegate:self
                                                         queue:nil];
    }
    return _centralM;
}


- (NSPointerArray *)delegateArr {
    if (!_delegateArr) {
        _delegateArr = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegateArr;
}





@end
