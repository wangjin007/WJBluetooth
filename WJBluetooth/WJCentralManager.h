//
//  WJCentralManager.h
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "WJCallback.h"
@interface WJCentralManager : NSObject

+ (instancetype)defaultManager;

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
 *  内部清空持有的所有设备
 */
- (BOOL)clearAllPeripherals;

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
