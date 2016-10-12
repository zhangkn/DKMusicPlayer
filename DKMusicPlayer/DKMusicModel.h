//
//  DKMusicModel.h
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 歌词模型*/
@interface DKMusicModel : NSObject

/** 歌名*/
@property (nonatomic,copy) NSString *name;
/** 歌曲文件名*/
@property (nonatomic,copy) NSString *filename;
/** 歌词文件名*/
@property (nonatomic,copy) NSString *lrcname;
/**歌手 */
@property (nonatomic,copy) NSString *singer;
/** 歌手头像*/
@property (nonatomic,copy) NSString *singerIcon;
/** 歌曲封面 */
@property (nonatomic,copy) NSString *icon;


//定义初始化方法 KVC的使用
//- (instancetype) initWithDictionary:(NSDictionary *) dict;
//+ (instancetype) <#name#>WithDictionary:(NSDictionary *) dict;







@end
