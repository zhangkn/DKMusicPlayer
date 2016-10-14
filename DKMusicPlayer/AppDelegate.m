//
//  AppDelegate.m
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)applicationDidEnterBackground:(UIApplication *)application{
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    /** 知识点：
     1>block会在定义那一刻，直接拿到外部的局部变量task的值。以后block中局部变量task的值就固定不变
     2>block中 对被————block修饰的变量的一直引用
     3》block中 对被————static修饰的变量的一直引用；对全局变量、成员变量也是能一致引用*/
    
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    /** 争取更高资格的方法：*/
    //1》 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 2》搞一个0kb的MP3文件，没有声音
    // 3》循环播放
}


@end
