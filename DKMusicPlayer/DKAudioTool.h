//
//  DKAudioTool.h
//  TestAVFoundation
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKAudioTool : NSObject
/** 播放音效*/
+ (void) playAudioWithFileName:(NSString*)fileName;

/** 销毁soundID*/

+ (void)audioServicesDisposeWithFileName:(NSString*)fileName;



@end
