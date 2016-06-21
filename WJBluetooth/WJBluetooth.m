//
//  WJBluetooth.m
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "WJBluetooth.h"

@interface WJBluetooth (){


    WJCentralManager *manager;
}
@end


@implementation WJBluetooth

+(instancetype)defalutBluetooth{

    static WJBluetooth *bluetooth = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        bluetooth = [[WJBluetooth alloc]init];
    });
    
    return bluetooth;
}

- (instancetype)init{

    if (self = [super init]) {
    
        [self initSetting];
    }
    return self;
}

- (void)initSetting{

  manager = [WJCentralManager defaultManager];
    
}



#pragma mark -public block callback method

- (void)centralManagerDidUpdateState:(centralManagerDidUpdateState)centralManagerDidUpdateState{

    [[WJCallback defaultCallback]setCentralManagerDidUpdateState:centralManagerDidUpdateState];
}

- (void)scanPeipheral:(scanPeripheral)scanPeripheral{

    [[WJCallback defaultCallback]setScanPeripheral:scanPeripheral];
}

- (void)connectedSuccess:(connectedSuccess)connectedSuccess{

    [[WJCallback defaultCallback]setConnectedSuccess:connectedSuccess];
}

- (void)connectedFailure:(connectedFailure)connectedFailure{

    [[WJCallback defaultCallback]setConnectedFailure:connectedFailure];
}

- (void)cancelConnected:(cancelConnected)cancelConnected{

    [[WJCallback defaultCallback]setCancelConnected:cancelConnected];
}

- (void)discoverServices:(discoverServices)discoverServices{
    
    [[WJCallback defaultCallback]setDiscoverServices:discoverServices];
}

- (void)discoverCharacteristic:(discoverCharacteristic)discoverCharacteristic{

    [[WJCallback defaultCallback]setDiscoverCharacteristic:discoverCharacteristic];
}

- (void)updateValueForCharacteristic:(updateValueForCharacteristic)updateValueForCharacteristic{
    
    [[WJCallback defaultCallback]setUpdateValueForCharacteristic:updateValueForCharacteristic];
}

- (void)discoverCharacteristicDescriptors:(discoverCharacteristicDescriptors)discoverCharacteristicDescriptors{

    [[WJCallback defaultCallback]setDiscoverCharacteristicDescriptors:discoverCharacteristicDescriptors];
}

- (void)readCharacteristicDescriptors:(readCharacteristicDescriptors)readCharacteristicDescriptors{

    [[WJCallback defaultCallback]setReadCharacteristicDescriptors:readCharacteristicDescriptors];
}

#pragma mark public operation

/**
 *  连接某个设备
 *
 *  @param peripheral 设备名称
 *  @param options    选项设置
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options{

    [manager connectPeripheral:peripheral options:options];

}

/**
 *  断开某个设备
 *
 *  @param peripheral 设备名称
 */
- (void)cancelPeripheral:(CBPeripheral *)peripheral{

    [manager cancelPeripheral:peripheral];
}

/**
 *  断开所有连接
 */
- (void)cancelAllPeripheral{

    [manager cancelAllPeripheral];
}

/**
 *  指定扫描哪些外设
 *
 *  @param serviceUUIDs 服务名称
 *  @param options      选项设置
 */
- (void)startScanWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options{

    [manager startScanWithServices:serviceUUIDs options:options];
}

/**
 *  扫描外设
 */
- (void)startScan{
    
    [manager startScan];
}

/**
 *  停止扫描
 */
- (void)stopScan{

    [manager stopScan];
}

/**
 *  写数据到特征
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 *  @param value          值
 */
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{

    [manager writeCharacteristic:peripheral characteristic:characteristic value:value];
}
/**
 *  设置通知
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 */
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{

    [manager notifyCharacteristic:peripheral characteristic:characteristic];
}

/**
 *  取消通知
 *
 *  @param peripheral     设备
 *  @param characteristic 特征
 */
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{

    [manager cancelNotifyCharacteristic:peripheral characteristic:characteristic];
}

/**
 *  扫描服务
 *
 *  @param peripheral   设备
 *  @param serviceUUIDs 服务uuid 可选 如果nil 扫描所有
 */
- (void)getServiesWithPeripheral:(CBPeripheral *)peripheral andServiceUUIDs:(nullable NSArray<CBUUID *> *)serviceUUIDs{


    [manager getServiesWithPeripheral:peripheral andServiceUUIDs:serviceUUIDs];
}


/**
 *  扫描特征
 *
 *  @param peripheral          设备
 *  @param characteristicUUIDs 特征uuid 可选 如果nil 扫描所有
 *  @param service             服务
 */
- (void)getCharacteristicsWithPeripheral:(CBPeripheral *)peripheral andCharacteristicUUIDS:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service{

    [manager getCharacteristicsWithPeripheral:peripheral andCharacteristicUUIDS:characteristicUUIDs forService:service];
}

/**
 *  读取特征的值
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)readValueforCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral{

    [manager readValueforCharacteristic:characteristic andPeripheral:peripheral];
}

/**
 *  发现特征描述
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral{

    [manager discoverDescriptorsForCharacteristic:characteristic andPeripheral:peripheral];

}
/**
 *  读取特征描述的值
 *
 *  @param descriptor 特征描述
 *  @param peripheral 设备
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor andPeripheral:(CBPeripheral *)peripheral{

    [manager readValueForDescriptor:descriptor andPeripheral:peripheral];
}


@end
