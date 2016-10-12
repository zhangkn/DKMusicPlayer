//
//  DKPlayingViewController.m
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "DKPlayingViewController.h"
#import "UIView+Extension.h"
#import "DKMusicModel.h"
#import "DKMusicTool.h"

#import "DKAudioTool.h"

@interface DKPlayingViewController ()

@end

@implementation DKPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showVC{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    //执行动画，让view从底部出来
    self.view.y = self.view.height;
    [UIView animateWithDuration:2.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //播放歌曲
        [self playingMusic:[DKMusicTool playingMusic]];        
    }];
}

- (void)playingMusic:(DKMusicModel*)model{
    [DKAudioTool playAudioWithFileName:model.filename];
//    [DKAudioTool playAudioWithFileName:@"buyao.wav"];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [DKAudioTool audioServicesDisposeWithFileName:[DKMusicTool playingMusic].filename];
}

@end
