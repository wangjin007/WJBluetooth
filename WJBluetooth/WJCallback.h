//
//  WJCallback.h
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//  获取状态
typedef void(^centralManagerDidUpdateState)(CBCentralManager *central);
// 扫描到设备回调
typedef void(^scanPeripheral)(CBPeripheral *peripheral,NSDictionary *advertisementData,NSNumber *RSSI);
// 连接成功回调
typedef void(^connectedSuccess)(CBCentralManager *central,CBPeripheral *peripheral);
// 连接失败回调
typedef void(^connectedFailure)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
// 断开连接回调
typedef void(^cancelConnected)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
// 扫描到服务
typedef void(^discoverServices)(CBPeripheral *peripheral,NSArray *services,NSError *error);
// 扫描到的特征
typedef void(^discoverCharacteristic)(CBPeripheral *peripheral,CBService *service,NSArray *characteristics, NSError *error);
// 获取特征的值
typedef void(^updateValueForCharacteristic)(CBPeripheral *peripheral,CBCharacteristic *characteristic, NSError *error);
// 搜索到Characteristic的Descriptors
typedef void(^discoverCharacteristicDescriptors)(CBPeripheral *peripheral,NSArray *descriptors,CBCharacteristic *characteristic, NSError *error);
// 读取到Descriptors的值
typedef void(^readCharacteristicDescriptors)(CBPeripheral *peripheral,CBDescriptor *descriptor, NSError *error);

@interface WJCallback : NSObject

@property(nonatomic,copy) centralManagerDidUpdateState centralManagerDidUpdateState;
@property(nonatomic,copy) scanPeripheral scanPeripheral;

@property(nonatomic,copy) connectedSuccess connectedSuccess;

@property(nonatomic,copy) connectedFailure connectedFailure;

@property(nonatomic,copy) cancelConnected cancelConnected;


@property(nonatomic,copy) discoverServices discoverServices;

@property(nonatomic,copy) discoverCharacteristic discoverCharacteristic;

@property(nonatomic,copy) updateValueForCharacteristic updateValueForCharacteristic;

@property(nonatomic,copy) discoverCharacteristicDescriptors discoverCharacteristicDescriptors;

@property(nonatomic,copy) readCharacteristicDescriptors readCharacteristicDescriptors;

+ (instancetype)defaultCallback;

@end
