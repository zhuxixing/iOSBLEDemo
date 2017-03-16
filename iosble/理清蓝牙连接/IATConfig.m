//
//  IATConfig.m
//  理清蓝牙连接
//
//  Created by ha netlab on 17/2/14.
//  Copyright © 2017年 qixiangkeji. All rights reserved.
//

#import "IATConfig.h"

@implementation IATConfig
@synthesize manager;
@synthesize delegate;
+(IATConfig *) sharedInstance{
    static IATConfig *sensor = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        sensor = [[IATConfig alloc] init];
    });
    return sensor;
}
-(void)setup{
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil ];
    self.isok1 = NO;
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (manager.state) {
        case CBCentralManagerStatePoweredOn:
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            break;
            
        default:
            NSLog(@"没有开启蓝牙");
            break;
    }
}
-(void) findPeripheral{
    switch (manager.state) {
        case CBCentralManagerStatePoweredOn:
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            break;
            
        default:
            break;
    }
}
-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
        NSLog(@"搜索到的外部设备%@",peripheral);
     //   if ([peripheral.name isEqualToString:@"范"]) {//尽量不要用这个用下边的广播名字
            if ([[ advertisementData objectForKey:@"kCBAdvDataLocalName"] isEqualToString:@"myPeripheral"]) {
                //[delegate peripheralFound:peripheral];
                self.peripheral =peripheral;
                [self.manager connectPeripheral:peripheral options:nil  ];
            }
           
      //  }
    
}
//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
    
 //   [self updateLog:[NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]];
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
   
//    [self updateLog:@"扫描服务"];
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接外设失败%@",error);
}
///连接成功后   获取服务后的回调  获取服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"lianjiechenggong             ....");
    if (error)
    {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    

    CBService *service = peripheral.services[4];//4
    [manager stopScan];
    [service.peripheral discoverCharacteristics:nil forService:service];
    //下边的
}
//上边的server 和 s 同一个类型
//获取特征后的回调  获取外设的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
//    
//     for (CBCharacteristic *c in service.characteristics)
//     {
//     NSLog(@"c.properties:%lu",(unsigned long)c.UUID) ;
//     //Subscribing to a Characteristic’s Value 订阅
//     [peripheral setNotifyValue:YES forCharacteristic:c];
//     // read the characteristic’s value，回调didUpdateValueForCharacteristic
//     //    读取外的的特征值
//     [peripheral readValueForCharacteristic:c];
//     self.writeRead = c ;
//     }
   // NSLog(@"%@",service.characteristics.count);
    
    self.characteristicRead = service.characteristics[0];//并非是真的读，其实是下位机的通知
    self.characteristicWrite = service.characteristics[1];
    [peripheral setNotifyValue:YES forCharacteristic:self.characteristicRead];
    NSLog(@"%@",self.characteristicRead.UUID);
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
  
    [delegate serialGATTCharValueUpdated:characteristic.value];
        NSLog(@"%@",characteristic.UUID);
}
-(void)write:(NSData *) data{

    [self.peripheral writeValue:data forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@">>>>>>>>>>%@",error);
    }else{
    
        }
        NSLog(@"写入成功");
        if (self.isok1 == YES) {
  
            [self.peripheral readValueForCharacteristic:self.characteristicRead];
        }
     NSLog(@"%@",characteristic.UUID);
}
//断开在连接
-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //    printf("CoreBluetooth is not correctly initialized !\n");
    NSLog(@"断开连接%@",error);
    //    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"断开连接！！！！请重新连接！！！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alter show];

    if (error.code ==7) {
        NSLog(@"%@",error);
        NSTimer *time = [[NSTimer alloc] init];
        time= [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(lianjie) userInfo:nil repeats:NO];
        self.peripheral = peripheral;
    }else{
        if (error==NULL) {
            NSLog(@"主动断开");
        }else{
            
            [self.manager connectPeripheral:peripheral options:nil];
        }
    }
    //    [self.manager connectPeripheral:peripheral options:nil];
    
}
-(void)lianjie{
    [self.manager connectPeripheral:self.peripheral options:nil];
}
-(void)lianjie:(CBPeripheral *)peripheral{
    
    self.peripheral = peripheral;
    [self.manager connectPeripheral:self.peripheral options:nil];

}
-(void)connect{
    
    [self.manager connectPeripheral:self.peripheral options:nil];

}
-(void)scanconnet{

    [self.manager cancelPeripheralConnection:self.peripheral];

}


@end
