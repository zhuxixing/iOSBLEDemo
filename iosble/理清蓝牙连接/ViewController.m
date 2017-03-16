//
//  ViewController.m
//  理清蓝牙连接
//
//  Created by ha netlab on 16/9/5.
//  Copyright © 2016年 qixiangkeji. All rights reserved.
//

#import "ViewController.h"
#import "IATConfig.h"
@interface ViewController ()<BTSmart>
@property (nonatomic,strong) IATConfig *senseor;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)UIButton *lb;
@property (nonatomic, strong)UIButton *btns;
@property (nonatomic)UInt64 ms1;
@property (nonatomic)UInt64 ms2;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.senseor = [IATConfig sharedInstance];
    [self.senseor setup];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               self.senseor.delegate = self;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,200, 200)];
    [btn setTitle:@"dian" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
   self.lb = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,100 , 100)];
    [btn addSubview:self.lb];
    [self.lb setTitle:@"123456789" forState:UIControlStateNormal];
    self.btns = [[UIButton alloc]initWithFrame:CGRectMake(200, 200,300 , 300)];
    [btn addSubview:self.btns];
     [self.btns setTitle:@"123456789" forState:UIControlStateNormal];
    [self.btns setBackgroundColor:[UIColor redColor]];
    
   // NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(send) userInfo:nil  repeats:YES];
}
-(void)serialGATTCharValueUpdated:(NSData *)data{//接收数据的方法
    //data及数据
    self.string1 = [NSString stringWithFormat:@"%@",data];
    if ([self.string1 isEqualToString:@"<31313131>"]) {
        self.ms2 = [[NSDate date] timeIntervalSince1970]*1000;
      //  NSLog(@"%f", [self.ms2 timeIntervalSinceDate: self.ms1 ]);
        [self.btns setTitle:[NSString stringWithFormat:@"%llu",(self.ms2-self.ms1)] forState:UIControlStateNormal];
    }
    [self.lb setTitle:self.string1 forState:UIControlStateNormal];
}
-(void)send{//往下位机写数据

  //  NSString *string = [NSString stringWithFormat:@"0%llu",self.ms1];
 //  NSData *data = [self stringToByte:@"00"];
  //  NSData *da = [self stringToByte:@"01"];
  //  UInt64 t = atoll([@"11" UTF8String]);

         self.ms1 = [[NSDate date] timeIntervalSince1970]*1000;
   // [self.senseor write:[self stringToByte:[NSString stringWithFormat:@"0%llu",self.ms1]]];
    [self.senseor write:[self stringToByte:@"1234"]];//转换成data类型，等同于其它语言的byte［］
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        NSData *data = [NSData dataWithBytes:tempbyt length:1];
        [bytes appendData:data];
    }
    return bytes;
}

@end
