//
//  WJCentralManager.m
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "WJCentralManager.h"

@interface WJCentralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

    /**
     *  系统蓝牙设备管理对象
     */
@property(nonatomic,strong) CBCentralManager *manager;

    /**
     *  保存发现设备的数组
     */
@property(nonatomic,strong) NSMutableArray *peripherals;


@end
@implementation WJCentralManager


+ (instancetype)defaultManager{

    static WJCentralManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[WJCentralManager alloc]init];
    });
    return manager;

}
- (instancetype)init{


    if (self = [super init]) {
        
         _manager =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    
    return self;
}

/************************CBCentralManagerDelegate代理方法***************************************/


#pragma mark--CBCentralManagerDelegate--

/**
 * 设备打开委托中 扫描外设
 *
 *  @param central
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    
    if ([WJCallback defaultCallback].centralManagerDidUpdateState) {
        
        [WJCallback defaultCallback].centralManagerDidUpdateState(central);
    }
}

/**
 *  扫描到外设会进入的方法
 *
 * */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    [WJCallback defaultCallback].scanPeripheral(peripheral,advertisementData,RSSI);
    //持有这个设备
        if (![self.peripherals containsObject:peripheral]) {
    
            [self.peripherals addObject:peripheral];
        }
}

#pragma mark --about connect--

/**
 * 连接设备成功
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    if ([WJCallback defaultCallback].connectedSuccess) {
        
        [WJCallback defaultCallback].connectedSuccess(central,peripheral);
    }
}

/**
 * 连接设备失败
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    if ([WJCallback defaultCallback].connectedFailure) {
        
        [WJCallback defaultCallback].connectedFailure(central,peripheral,error);
    }
}

/**
 * 设备断开连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    if ([WJCallback defaultCallback].cancelConnected) {
        
        [WJCallback defaultCallback].cancelConnected(central,peripheral,error);
    }
}

/************************CBPeripheralDelegate代理方法***************************************/

#pragma mark --CBPeripheralDelegate--
/**
 *  扫描到服务
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    if ([WJCallback defaultCallback].discoverServices) {
        
         [WJCallback defaultCallback].discoverServices(peripheral,peripheral.services,error);
    }
}

/**
 *  扫描到Characteristics
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if ([WJCallback defaultCallback].discoverCharacteristic) {
       
        [WJCallback defaultCallback].discoverCharacteristic(peripheral,service,service.characteristics,error);
    }
}

/**
 *  获取characteristic的值
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    
    if ([WJCallback defaultCallback].updateValueForCharacteristic) {
        
        [WJCallback defaultCallback].updateValueForCharacteristic(peripheral,characteristic,error);
    }
}
/**
 *  搜索到Characteristic的Descriptors
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    
    if ([WJCallback defaultCallback].discoverCharacteristicDescriptors) {
        
        [WJCallback defaultCallback].discoverCharacteristicDescriptors(peripheral,characteristic.descriptors,characteristic,error);
    }
}
/**
 * 获取到Descriptors的值
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    
    if ([WJCallback defaultCallback].readCharacteristicDescriptors) {
        
        [WJCallback defaultCallback].readCharacteristicDescriptors(peripheral,descriptor,error);
    }
}


#pragma mark --public operations


#pragma mark ----connect--

/**
 *  连接某个设备
 *
 *  @param peripheral 设备名
 *  @param options    选项设置
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options{
    
    [_manager connectPeripheral:peripheral options:options];
}

/**
 *  断开某个设备
 *
 *  @param peripheral 设备名
 */
- (void)cancelPeripheral:(CBPeripheral *)peripheral{
    
    [_manager cancelPeripheralConnection:peripheral];
}

/**
 *  断开所有链接设备
 */
- (void)cancelAllPeripheral{
    
    for (CBPeripheral *peripheral in self.peripherals) {
        
        [_manager cancelPeripheralConnection:peripheral];
    }
}

#pragma mark ----scan peripheral--

/**
 *  开始扫描
 *
 *  @param serviceUUIDs 指定扫哪些服务的外设
 *  @param options      选项
 */
- (void)startScanWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options{
    
    [_manager scanForPeripheralsWithServices:serviceUUIDs options:options];
}

/**
 *  默认扫描所有外设
 */
- (void)startScan{
    
    [_manager scanForPeripheralsWithServices:nil options:nil];
}


/**
 *  停止扫描
 */
- (void)stopScan{
    
    [_manager stopScan];
}
#pragma mark ----write data--

/**
 *  写数据到characteristic中
 */
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    //只有 characteristic.properties 有write的权限才可以写
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }
    
}


#pragma mark ----notify--

/**
 * 设置通知
 */
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}
/**
 * 取消通知
 */
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

/**
 *  清除所有持有设备
 *
 *  @return yes/no
 */
- (BOOL)clearAllPeripherals{

    if (self.peripherals.count>0) {
        
        [self.peripherals removeAllObjects];
        return YES;
    }
    return NO;
}


/**
 *  扫描服务
 *
 *  @param peripheral   设备
 *  @param serviceUUIDs 服务uuid 可选 如果nil 扫描所有
 */
- (void)getServiesWithPeripheral:(CBPeripheral *)peripheral andServiceUUIDs:(nullable NSArray<CBUUID *> *)serviceUUIDs{
    
    peripheral.delegate = self;
    [peripheral discoverServices:serviceUUIDs];
}

/**
 *  扫描特征
 *
 *  @param peripheral          设备
 *  @param characteristicUUIDs 特征uuid 可选 如果nil 扫描所有
 *  @param service             服务
 */
- (void)getCharacteristicsWithPeripheral:(CBPeripheral *)peripheral andCharacteristicUUIDS:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service{

    [peripheral discoverCharacteristics:characteristicUUIDs forService:service];
}

/**
 *  读取特征的值
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)readValueforCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral{

    [peripheral readValueForCharacteristic:characteristic];
}

/**
 *  发现特征描述
 *
 *  @param characteristic 特征
 *  @param peripheral     设备
 */
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic andPeripheral:(CBPeripheral *)peripheral{

    [peripheral discoverDescriptorsForCharacteristic:characteristic];
}

/**
 *  读取特征描述的值
 *
 *  @param descriptor 特征描述
 *  @param peripheral 设备
 */
- (void)readValueForDescriptor:(CBDescriptor *)descriptor andPeripheral:(CBPeripheral *)peripheral{
    
    [peripheral readValueForDescriptor:descriptor];
}



#pragma mark set/get

- (NSMutableArray *)peripherals{

    if (!_peripherals) {
        _peripherals = [[NSMutableArray alloc]init];
    }
    return _peripherals;
}

@end
