//
//  ViewController.m
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
/****************************************************
 * 
 *  设备接收端的蓝牙接口的调用
 *  此demo 主要信息看打印log 由于时间原因 没有做tableview的显示
 *  连接的蓝牙外设的型号 是提前设定过的 可以自己更改 根据扫描到的设备name 或者identify 
 *  此测试的蓝牙设备的 
    设备名称: TI BLE Peripheral:01
    服务 UUID: FFF0
    特征 UUID: FFF4 为notify订阅类型
 *  
    调用逻辑
 *  先判断自己设备蓝牙的状态
 *  扫描蓝牙外设
    连接需要连接的外设
    扫描连接外设的服务
    扫描服务中的特征
    读取特征值
    判读特征的类型  类型三种 read write notify 本demo测试的notify 读写接口已提供未测试
    进行订阅特征/取消订阅
 **************************/
//

#import "ViewController.h"
#import "WJBluetooth.h"
@interface ViewController ()
@property(nonatomic,strong)WJBluetooth *blutetooth;
@property(nonatomic,strong) NSMutableArray *peripheralsArr;

@property(nonatomic,strong) CBPeripheral *mainPeripheral;
@property(nonatomic,strong) CBCharacteristic *notifyCharacteristic;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blutetooth = [WJBluetooth defalutBluetooth];
    
    /**
     *  代理方法回调
     */
    [self bluetoothCallback];
   
}

- (void)bluetoothCallback{

    //获取蓝牙状态回调
    [_blutetooth centralManagerDidUpdateState:^(CBCentralManager *central) {
        
        if (central.state == CBCentralManagerStatePoweredOn) {
            
            
            NSLog(@"开始扫描设备");
            
            [_blutetooth startScan];
        }
    }];
    
    //扫描外部设备回调
    [_blutetooth scanPeipheral:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
       
        NSLog(@"peripheralName:%@ advertisementData:%@ RSSI:%@",peripheral.name,advertisementData,RSSI);
        
        /**
         *  持有设备对象
         */
        [self.peripheralsArr addObject:peripheral];
        
        /**
         *  连接设备
         * 这里可以加条件判断 连接哪个设备
         * 也可以自己在ui界面加一个连接button 或者 把搜索到的设备信息 以tableview形式展示 然后点击cell时连接相应的设备
         */
        //测试设备名称:peripheralName:TI BLE Peripheral:01
        
        if ([peripheral.name isEqualToString:@"TI BLE Peripheral:01" ]) {
            
            [_blutetooth connectPeripheral:peripheral options:nil];
            
            /**
             *  停止扫描
             */
            [_blutetooth stopScan];
        }
    }];
    
    //连接成功回调
    [_blutetooth connectedSuccess:^(CBCentralManager *central, CBPeripheral *peripheral) {
       
        NSLog(@"设备:%@连接成功",peripheral.name);
        
        /**
         *  连接成功后开始扫描服务
         */
        
        [_blutetooth getServiesWithPeripheral:peripheral andServiceUUIDs:nil];
    }];
    
    //扫描到服务回调
    [_blutetooth discoverServices:^(CBPeripheral *peripheral, NSArray *services, NSError *error) {
       
        
        NSLog(@"services%@",services);
        
        /**
         *  找到相应的服务 扫描需要的特征
         */
        for (CBService *service in services ) {
            /**
             *  这里修改为自己服务的uuid
             */
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]]) {
                
                //查找此服务的特征
                [_blutetooth getCharacteristicsWithPeripheral:peripheral andCharacteristicUUIDS:nil forService:service];
            }
        }
    }];
    
    //扫描到特征回调
    [_blutetooth discoverCharacteristic:^(CBPeripheral *peripheral, CBService *service, NSArray *characteristics, NSError *error) {
       
        NSLog(@"characteristics%@",characteristics);
        
        for (CBCharacteristic *cha in characteristics) {
            
            /**
             *  这里修改为自己特征的uuid
             */
            if ([cha.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]]) {
                
                
                /**
                 *  存取设备与特征
                 */
                _mainPeripheral = peripheral;
                _notifyCharacteristic = cha;
                
                /**
                 *  读取特征值
                 */
                [_blutetooth readValueforCharacteristic:cha andPeripheral:peripheral];
            }
        }
    }];
    
    //特征值回调
    
    [_blutetooth updateValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
       
        NSLog(@"characteristic value:%@",characteristic.value);
        
        /**
         *  这里一般会根据硬件提供的文档 进行数据包的解析
         */
        
    }];
}


- (NSMutableArray *)peripheralsArr{

    if (!_peripheralsArr) {
        _peripheralsArr = [[NSMutableArray alloc]init];
    }
    return _peripheralsArr;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (_notifyCharacteristic) {
        
        if (_notifyCharacteristic.isNotifying) {
            
            [_blutetooth cancelNotifyCharacteristic:_mainPeripheral characteristic:_notifyCharacteristic];
        }else{
            [_blutetooth notifyCharacteristic:_mainPeripheral characteristic:_notifyCharacteristic];
        }
    }else{
    
        NSLog(@"请根据自己的蓝牙设备 进行连接和notify特征的读取");
    }
    
}

@end
