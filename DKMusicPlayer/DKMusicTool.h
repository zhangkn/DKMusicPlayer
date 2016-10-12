//
//  DKMusicTool.h
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DKMusicModel;
@interface DKMusicTool : NSObject

/**
 提供类方法，返回数据模型数组--工厂模式   获取所有音乐
 */
+ (NSMutableArray *) musicModelList;
/** 获取正在播放的音乐*/
+ (DKMusicModel*)playingMusic;
/** 设置播放的音乐 */
+ (BOOL)setPlayingMusic:(DKMusicModel*)music;

/**下一首 */
+ (DKMusicModel*)nextPlayingMusic;
/** 上一首*/
+ (DKMusicModel*)forwardPlayingMusic;




@end
