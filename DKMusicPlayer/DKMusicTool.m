//
//  DKMusicTool.m
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "DKMusicTool.h"
#import "DKMusicModel.h"
#import "MJExtension.h"
#import <AVFoundation/AVFoundation.h>

@implementation DKMusicTool

static  NSMutableArray *_musicList;

static  DKMusicModel *_playingMusic;






+(void)initialize{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _musicList = [self musicList];
    });
    
    
}

+ (NSMutableArray *)musicModelList{
    return _musicList;
}

+ (NSMutableArray *)musicList{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:2];
    //加载资源
    NSString *plistPath= [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
    
    NSArray *musicDictArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    tmp = [DKMusicModel mj_objectArrayWithKeyValuesArray:musicDictArray ];
    return tmp;
}

+ (BOOL )setPlayingMusic:(DKMusicModel *)music{
    if (music == nil || ![_musicList containsObject:music]) {
        return NO;
    }
    _playingMusic = music;
    return YES;
    
}

+ (DKMusicModel *)playingMusic{
    return _playingMusic;
}

+ (DKMusicModel *)nextPlayingMusic{
    NSUInteger currentIndex;
    if (_playingMusic == nil) {
        currentIndex = 0;
    }else{
        currentIndex =  [_musicList indexOfObject:_playingMusic];
    }
    NSUInteger nextIndex = currentIndex++;
    if (nextIndex >= _musicList.count) {
         nextIndex = 0;// 返回第一首
    }
    DKMusicModel *tmp  = [_musicList objectAtIndex:nextIndex];
    return tmp;
}

+ (DKMusicModel *)forwardPlayingMusic{
    NSUInteger currentIndex;
    if (_playingMusic == nil) {
        currentIndex =0;
    }else{
        currentIndex =  [_musicList indexOfObject:_playingMusic];
    }
   NSUInteger  preIndex;
    if (currentIndex == 0) {
        preIndex = _musicList.count-1;// 返回最后一首
    }else{
        preIndex = currentIndex--;
    }
    DKMusicModel *tmp  = [_musicList objectAtIndex:preIndex];
    return tmp;
    
}





@end
