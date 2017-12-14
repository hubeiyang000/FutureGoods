//
//  NotificationManager.m
//  BTC-Kline
//
//  Created by liuyang on 2017/7/24.
//  Copyright © 2017年 yate1996. All rights reserved.
//

#import "NotificationManager.h"
#import <UIKit/UIKit.h>

@implementation NotificationManager

- (void)creatLocalNotificationWithshadowLineHeight:(float)shadowLineHeight
                                  entityLineHeight:(float)entityLineHeight
                                              date:(NSString *)dateStr{
    
    if (shadowLineHeight/entityLineHeight >=2.5) {
        //画线时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.doubleValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        double lineDate = [date timeIntervalSince1970];
        
        //当前时间
        NSDate *now = [dateFormatter dateFromString:@"2017-07-24 18:30"];
        NSTimeInterval nowInterval = [now timeIntervalSince1970];
        if ((nowInterval - lineDate)>0 &&(nowInterval - lineDate)<(24*60*60)) {
            NSString *dateStr = [dateFormatter stringFromDate:date];
            NSLog(@"本地通知,date:%@",dateStr);
            //[self registLocalNotification];
        }
    }
}

- (void)registLocalNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    notification.fireDate           = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.alertBody          = @"alertBody";
    notification.alertLaunchImage   = @"icon.png";
    
    //如果通知提醒样式为横幅则alertAction属性无显示 样式为提醒的时候alertAction显示为UIAlertView的右侧按钮
    notification.alertAction        = @"alertAction";
    
    //提示音
    notification.soundName          = UILocalNotificationDefaultSoundName;
    //时区
    notification.timeZone           = [NSTimeZone defaultTimeZone];
    
    //0表示不重复,这里可以设置成每天,每小时等等
    notification.repeatInterval     = 0;
    
    //userInfo用来存储一些信息,比如用于区别其他通知的id等等
    notification.userInfo           = [NSDictionary dictionaryWithObjectsAndKeys:@"tag", @"id",nil];
    notification.applicationIconBadgeNumber = 1;
    
    //生效时间根据fireDate确定
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //立即生效的通知,与fireDate无关
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    //取消通知可以用下面的方法
    //[[UIApplication sharedApplication] cancelLocalNotification:notification];
    //取消全部到本地通知
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //通过userInfo来区分不同的通知
    /*
     for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
     NSString *indentiString = [notification.userInfo objectForKey:@"id"];
     if ([indentiString isEqualToString:@"tag"] == YES) {
     [[UIApplication sharedApplication] cancelLocalNotification:notification];
     }
     }
     */
}

@end
