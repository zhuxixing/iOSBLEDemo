//
//  IATConfig.h
//  理清蓝牙连接
//
//  Created by ha netlab on 17/2/14.
//  Copyright © 2017年 qixiangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
@protocol BTSmart

@optional

- (void) peripheralFound:(CBPeripheral *)peripheral;
-(void)serialGATTCharValueUpdated : (NSData *)data;

-(void)dismiss;


@end
@interface IATConfig : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) CBCentralManager *manager;
@property (nonatomic,strong) id<BTSmart> delegate;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) CBCharacteristic *writeRead;
@property (nonatomic,strong) CBCharacteristic *characteristic;

@property (nonatomic,strong) CBCharacteristic *characteristicWrite;
@property (nonatomic,strong) CBCharacteristic *characteristicRead;


@property (nonatomic,strong)  NSMutableData *dataMutable;
@property (nonatomic,strong)  NSMutableData *dataMutable1;
@property (nonatomic,strong)  NSMutableData *dataMutable3;

@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic) BOOL isok1;

+(IATConfig *) sharedInstance;
-(void) setup;
-(void) findPeripheral;
-(void)lianjie:(CBPeripheral *)peripheral;
-(void)lianjie;
-(void)connect;
-(void) scanconnet;
-(void)write:(NSData *) data;
//-(void)writecha:(NSData*)data:(int)p;
//-(void) writeArray:(NSArray *) array kaiguan:(BOOL )isok daihao:(NSString *)string ;
@end
