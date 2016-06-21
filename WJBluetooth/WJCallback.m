//
//  WJCallback.m
//  WJBluetooth
//
//  Created by wangjin on 16/6/17.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "WJCallback.h"

@implementation WJCallback

+ (instancetype)defaultCallback{

    static WJCallback *callback = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        callback = [[WJCallback alloc]init];
    });
    return callback;
}
@end
