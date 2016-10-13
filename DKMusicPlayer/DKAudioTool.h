//
//  DKAudioTool.h
//  TestAVFoundation
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;
@interface DKAudioTool : NSObject
#pragma mark - /** 播放音效*/
+ (void) playAudioWithFileName:(NSString*)fileName;

/** 销毁soundID 音效*/
+ (void)audioServicesDisposeWithFileName:(NSString*)fileName;
#pragma mark -  /** 播放音乐  AVAudioPlayer*/
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;
+ (void)pauseMusicWithFilename:(NSString  *)filename;
+ (void)stopMusicWithFilename:(NSString  *)filename;




@end
