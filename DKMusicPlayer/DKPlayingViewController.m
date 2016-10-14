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
#import <AVFoundation/AVFoundation.h>

@interface DKPlayingViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinngerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 滑块*/
@property (weak, nonatomic) IBOutlet UIButton *slider;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UIView *progressView;
/** 显示拖拽进度*/
@property (weak, nonatomic) IBOutlet UIButton *showProgressButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseMusicButton;




@property (strong, nonatomic)  DKMusicModel *currentPlayingMusic;

/** 当前的播放器*/
@property (strong, nonatomic)  AVAudioPlayer *audioPlayer;
/** 定时器，用于时时监听进度 */
@property (strong, nonatomic)  NSTimer  *timer;


@end

@implementation DKPlayingViewController

#define DKAnimateWithDuration 2.0
#define DkKeyWindow [UIApplication sharedApplication].keyWindow

- (IBAction)hide:(id)sender {
    [DkKeyWindow setUserInteractionEnabled:NO];
    [UIView animateWithDuration:DKAnimateWithDuration animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        [DkKeyWindow setUserInteractionEnabled:YES];
        [self removeProgressTimer];
    }];

    
}

- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer{
    _audioPlayer = audioPlayer;
    audioPlayer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showProgressButton.layer.cornerRadius =8;
    [self.pauseMusicButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.pauseMusicButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];

    
}

- (void)showVC{
    //禁用交互
    [DkKeyWindow setUserInteractionEnabled:NO];
    self.view.frame = DkKeyWindow.bounds;
    [DkKeyWindow addSubview:self.view];
    //判断是否切歌
    if(![self.currentPlayingMusic isEqual:[DKMusicTool playingMusic]]){
        [self resetParasForchangeMusic:nil];
        [self removeProgressTimer];
        [self showVCWithCompletionBlock:^{
            //播放歌曲
            [DkKeyWindow setUserInteractionEnabled:YES];
            self.currentPlayingMusic = [DKMusicTool playingMusic];
            [self playingMusic:self.currentPlayingMusic];
            [self addProgressTimer];// 今天进度
        }];
        return;
    }
    [self showVCWithCompletionBlock:^{
        [self addProgressTimer];//监听进度
        [DkKeyWindow setUserInteractionEnabled:YES];
    }];
   
}

- (void)resetParasForchangeMusic:(void(^)())playblock{
    //停止当前的歌曲
    [DKAudioTool stopMusicWithFilename:self.currentPlayingMusic.filename];
    if (playblock) {
        playblock();
    }
    [self setupProgressViewsWith:0.0];
    [self setupData];//更新数据
    //切换播放状态
    self.pauseMusicButton.selected = NO;//正在播放状态
  
}

/**     //执行动画，让view从底部出来
 completionBlock 动画结束执行的代码
 */
- (void)showVCWithCompletionBlock:(void (^)())completionBlock{
    self.view.y = self.view.height;
    self.view.hidden = NO;
    [UIView animateWithDuration:DKAnimateWithDuration animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)setupData{
    DKMusicModel *model =  [DKMusicTool playingMusic] ;
    self.nameLabel.text =model.name;
    self.sinngerNameLabel.text = model.singer;
    self.coverImageView.image = [UIImage imageNamed:model.icon];
    
}

- (void)playingMusic:(DKMusicModel*)model{
    self.audioPlayer = [DKAudioTool playMusicWithFilename:model.filename];
    //设置总时长
    self.totalTimeLabel.text = [self timeStringWithTimeInterval:self.audioPlayer.duration];

}

- (NSString*)timeStringWithTimeInterval:(NSTimeInterval)timeInterval{
    return [NSString stringWithFormat:@"%d:%d",(int)timeInterval/60,((int)timeInterval%60)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [DKAudioTool stopMusicWithFilename:self.currentPlayingMusic.filename];
    self.audioPlayer = nil;
}

#pragma mark - 进度条控制相关方法

-(void)addProgressTimer{
    if (![self.audioPlayer isPlaying]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatepPlayingMusicProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)removeProgressTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)updatepPlayingMusicProgress{
    //更新进度
    if (![self.audioPlayer isPlaying]) {
        return;
    }
    double currentProfress = self.audioPlayer.currentTime/self.audioPlayer.duration;
    [self setupProgressViewsWith:currentProfress];
}

#define DKSliderMaxX self.view.width - self.slider.width

- (void)setupProgressViewsWith:(double)currentProfress{
    //显示数据到界面
    //修改控件frame
    //滑块移动的最大距离
    CGFloat sliderMaxX = DKSliderMaxX;
    self.slider.x = sliderMaxX*currentProfress;
    self.progressView.width = self.slider.center.x;
    NSString *currentProfressString;
    if (currentProfress == 0.0) {
        currentProfressString = @"0:0";
    }else{
        currentProfressString = [self timeStringWithTimeInterval:self.audioPlayer.duration*currentProfress];
    }
    [self.slider setTitle:currentProfressString forState:UIControlStateNormal];
    
}

#pragma mark - AVAudioPlayerDelegate
/** 设置播放模式*/
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self nextMusic:nil];
}



/** 进度条拖动*/
- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];// sender.view = self.bankgroundView
    CGFloat sliderMaxX = DKSliderMaxX;
    double currentProfress = (point.x)/sliderMaxX;
    self.audioPlayer.currentTime = currentProfress * self.audioPlayer.duration;
    [self setupProgressViewsWith:currentProfress];
}



// 监听滑块拖拽事件
- (IBAction)panProgressButton:(UIPanGestureRecognizer *)sender {
    //获取点击的point
    CGPoint point = [sender translationInView:sender.view];// sender.view = self.slider  获取平移的位置
    [sender setTranslation:CGPointZero inView:sender.view];
    //1.计算点击的进度
    CGFloat sliderMaxX = DKSliderMaxX;
    double currentProfress = (self.slider.x+point.x)/sliderMaxX;
    if (currentProfress>1.0) {
        currentProfress =1.0;
    }else if(currentProfress<0){
        currentProfress = 0;
    }
    [self setupProgressViewsWith:currentProfress];
       // 3.判断当前的state状态
    // 如果是开始拖拽就停止定时器, 如果结束拖拽就开启定时器
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.showProgressButton.hidden = NO;        // 显示进度的方块
        // 开始拖拽
        NSLog(@"开始拖拽, 停止定时器");
        [self removeProgressTimer];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        // 结束拖拽
        self.showProgressButton.hidden = YES;
        self.audioPlayer.currentTime  = currentProfress*self.audioPlayer.duration;// 决定滑块的标题显示的进度
        if (self.audioPlayer.playing) {
            NSLog(@"结束拖拽, 开启定时器");
            [self addProgressTimer];
        }
    }else if(sender.state == UIGestureRecognizerStateChanged){
        // 2.设置显示进度的方块的frame
        NSString *currentProfressString = self.slider.currentTitle;
        [self.showProgressButton setTitle:currentProfressString forState:UIControlStateNormal];
        self.showProgressButton.x = self.slider.x;
        self.showProgressButton.y = self.showProgressButton.superview.height - self.showProgressButton.height - 10;
    }
    
}

#pragma mark - 播放相关方法

- (IBAction)pauseMusic:(UIButton *)sender {
    //修改对应的状态
    sender.selected = !sender.selected;
    if (sender.selected) {
        [DKAudioTool pauseMusicWithFilename:[DKMusicTool playingMusic].filename];
        [self removeProgressTimer];
        return;
    }
    //继续播放
    double currentProfress = self.audioPlayer.currentTime/self.audioPlayer.duration;
    [self setupProgressViewsWith:currentProfress];
    self.audioPlayer= [DKAudioTool playMusicWithFilename:self.currentPlayingMusic.filename];
    [self addProgressTimer];
}
#define weakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

- (IBAction)nextMusic:(UIButton *)sender {
    weakSelf(weakSelf);
    [self resetParasForchangeMusic:^{
        [weakSelf setupChangeMusic:[DKMusicTool nextPlayingMusic]];
    }];
    
}
- (IBAction)previousMusic:(UIButton *)sender {
    weakSelf(weakSelf);
    [self resetParasForchangeMusic:^{
        [weakSelf setupChangeMusic:[DKMusicTool forwardPlayingMusic]];
    }];
}

- (void)setupChangeMusic:(DKMusicModel*)music{
    self.currentPlayingMusic = music;
    self.audioPlayer= [DKAudioTool playMusicWithFilename:self.currentPlayingMusic.filename];
    [DKMusicTool setPlayingMusic:self.currentPlayingMusic];
}



@end
