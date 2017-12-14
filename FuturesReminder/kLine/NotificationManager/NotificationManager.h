//
//  NotificationManager.h
//  BTC-Kline
//
//  Created by liuyang on 2017/7/24.
//  Copyright © 2017年 yate1996. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

- (void)creatLocalNotificationWithshadowLineHeight:(float)shadowLineHeight
                                  entityLineHeight:(float)entityLineHeight
                                              date:(NSString *)dateStr;

@end
