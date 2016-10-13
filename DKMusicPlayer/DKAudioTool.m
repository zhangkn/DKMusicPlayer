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
static NSMutableDictionary *_players;

+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

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



// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return nil;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (!player) {
        NSLog(@"创建新的播放器");
        
        // 2.1根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 2.2判断url是否为nil
        if (!url) {
            return nil;
        }
        
        // 2.3创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.4准备播放
        if(![player prepareToPlay])
        {
            return nil;
        }
        // 允许快进
        player.enableRate = YES;
        player.rate = 1;
        
        // 2.5将播放器添加到字典中
        [self players][filename] = player;
        
    }
    // 3.播放音乐
    if (!player.playing)
    {
        [player play];
    }
    
    return player;
}

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.playing)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player stop];
        // 2.2清空播放器
        //        player = nil;
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:filename];
    }
}

@end
