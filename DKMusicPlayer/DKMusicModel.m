//
//  DKMusicModel.m
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "DKMusicModel.h"

@implementation DKMusicModel



- (BOOL)isEqual:(id)other
{
    if (!other) {
        return NO;
    }
//    *filename;
//    /** 歌词文件名*/
//    @property (nonatomic,copy) NSString *lrcname;
//    /**歌手 */
//    @property (nonatomic,copy) NSString *singer;
//    /** 歌手头像*/
//    @property (nonatomic,copy) NSString *singerIcon;
//    /** 歌曲封面 */
//    @property (nonatomic,copy) NSString *icon;
    DKMusicModel *otherModel = (DKMusicModel*)other;
    if ([otherModel.name isEqualToString: self.name] && [otherModel.singer isEqualToString:self.singer] && [otherModel.icon isEqualToString:self.icon]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)hash
{
    return self.name.hash + self.icon.hash +self.singer.hash;
}




@end
