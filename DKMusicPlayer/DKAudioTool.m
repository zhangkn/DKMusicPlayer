//
//  DKAudioTool.m
//  TestAVFoundation
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "DKAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation DKAudioTool


static NSMutableDictionary *_inSystemSoundIDs;

+ (void)initialize{
    if (_inSystemSoundIDs == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _inSystemSoundIDs = [NSMutableDictionary dictionary];
        });
    }
}

+(void)playAudioWithFileName:(NSString *)fileName{
    if (fileName == nil) {
        return;
    }
    //获取inSystemSoundID,并播放音效
    SystemSoundID systemSoundID =[self systemSoundIDWithFileName:fileName];
    if (systemSoundID == 0) {//无效的音频文件名称
        return;
    }
    AudioServicesPlaySystemSound(systemSoundID);
}

/** 使用全局的静态变量存储ID，保证只加载一次资源*/
+ (SystemSoundID)systemSoundIDWithFileName:(NSString *)fileName{
    SystemSoundID inSystemSoundID = [_inSystemSoundIDs[fileName] unsignedIntValue];
    if (inSystemSoundID ) {
        return inSystemSoundID;
    }
    CFURLRef inFileURL = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:fileName withExtension:nil]);
    if (inFileURL == nil) {
        return 0;
    }
    //加载音效
    AudioServicesCreateSystemSoundID( inFileURL , &inSystemSoundID);
    //播放音效（本地）
    [_inSystemSoundIDs setObject:[NSNumber numberWithInt:inSystemSoundID] forKey:fileName];
    return inSystemSoundID;
}

+(void)audioServicesDisposeWithFileName:(NSString *)fileName{
    if (fileName == nil) {
        return;
    }
    SystemSoundID inSystemSoundID = [_inSystemSoundIDs[fileName] unsignedIntValue];
    if (!inSystemSoundID ) {
        return ;
    }
    AudioServicesDisposeSystemSoundID(inSystemSoundID);
    //移除soundID
    [_inSystemSoundIDs removeObjectForKey:fileName];
}



@end
