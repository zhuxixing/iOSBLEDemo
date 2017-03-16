//
//  ViewController.h
//  理清蓝牙连接
//
//  Created by ha netlab on 16/9/5.
//  Copyright © 2016年 qixiangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
+(ViewController *)instance;
void _startup(void);
void  _receive(char *string);
@end

