//
//  WJBluetooth.h
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "WJCentralManager.h"
#import "WJCallback.h"

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
@interface WJBluetooth : NSObject

/**
 *  获取状态block
 */
@property(nonatomic,copy) centralManagerDidUpdateState centralManagerDidUpdateState;
/**
 *  扫描设备block
 */
@property(nonatomic,copy) scanPeripheral scanPeripheral;
/**
 *  连接成功block
 */
@property(nonatomic,copy) connectedSuccess connectedSuccess;
/**
 *  连接失败block
 */
@property(nonatomic,copy) connectedFailure connectedFailure;
/**
 *  断开连接block
 */
@property(nonatomic,copy) cancelConnected cancelConnected;

/**
 *  发现服务block
 */
@property(nonatomic,copy) discoverServices discoverServices;
/**
 *  发现特征block
 */
@property(nonatomic,copy) discoverCharacteristic discoverCharacteristic;
/**
 *  更新特征值block
 */
@property(nonatomic,copy) updateValueForCharacteristic updateValueForCharacteristic;
/**
 *  发现特征描述block
 */
@property(nonatomic,copy) discoverCharacteristicDescriptors discoverCharacteristicDescriptors;
/**
 *  更新特征描述值block
 */
@property(nonatomic,copy) readCharacteristicDescriptors readCharacteristicDescriptors;

/**
 *  单例
 *
 */
+(instancetype)defalutBluetooth;

#pragma mark -- call block

/**
 *  状态改变回调
 *
 */
- (void)centralManagerDidUpdateState:(centralManagerDidUpdateState)centralManagerDidUpdateState;
/**
 *  扫描到设备回调
 *
 */
- (void)scanPeipheral:(scanPeripheral)scanPeripheral;

/**
 *  连接成功回调
 *
 */
- (void)connectedSuccess:(connectedSuccess)connectedSuccess;
/**
 *  连接失败回调
 *
 */
- (void)connectedFailure:(connectedFailure)connectedFailure;
/**
 *  断开连接回调
 *
 */
- (void)cancelConnected:(cancelConnected)cancelConnected;
/**
 *  发现服务回调
 *
 */
- (void)discoverServices:(discoverServices)discoverServices;
/**
 *  发现特征回调
 *
 */
- (void)discoverCharacteristic:(discoverCharacteristic)discoverCharacteristic;
/**
 *  更新特征回调
 *
 */
- (void)updateValueForCharacteristic:(updateValueForCharacteristic)updateValueForCharacteristic;
/**
 *  发现特征描述回调
 *
 */
- (void)discoverCharacteristicDescriptors:(discoverCharacteristicDescriptors)discoverCharacteristicDescriptors;
/**
 *  读取特征描述回调
 *
 */
- (void)readCharacteristicDescriptors:(readCharacteristicDescriptors)readCharacteristicDescriptors;


#pragma mark public operation

/**
 *  连接某个设备
 *
 *  @param peripheral 设备名称
 *  @param options    选项设置
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;

/**
 *  断开某个设备
 *
 *  @param peripheral 设备名称
 */
- (void)cancelPeripheral:(CBPeripheral *)peripheral;

/**
 *  断开所有连接
 */
- (void)cancelAllPeripheral;

/**
 *  指定扫描哪些外设
 *
 *  @param serviceUUIDs 服务名称
 *  @param options      选项设置
 */
- (void)startScanWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options;

/**
 *  扫描外设
 */
- (void)startScan;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  写数据到特征
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 *  @param value          值
 */
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value;
/**
 *  设置通知
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 */
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic;

/**
 *  取消通知
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 */
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic;

/**
 *  扫描服务
 *
 *  @param peripheral   设备
 *  @param serviceUUIDs 服务uuid 可选 如果nil 扫描所有
 */
- (void)getServiesWithPeripheral:(CBPeripheral *)peripheral andServiceUUIDs:(nullable NSArray<CBUUID *> *)serviceUUIDs;

/**
 *  扫描特征
 *
 *  @param peripheral          设备
 *  @param characteristicUUIDs 特征uuid 可选 如果nil 扫描所有
 *  @param service             服务
 */
- (void)getCharacteristicsWithPeripheral:(CBPeripheral *)peripheral andCharacteristicUUIDS:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service;

/**
 *  读取特征的值
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)readValueforCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral;

/**
 *  发现特征描述
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral;
/**
 *  读取特征描述的值
 *
 *  @param descriptor 特征描述
 *  @param peripheral 设备
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor andPeripheral:(CBPeripheral *)peripheral;


@end
