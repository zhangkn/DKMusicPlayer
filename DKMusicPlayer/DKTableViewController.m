//
//  DKTableViewController.m
//  DKMusicPlayer
//
//  Created by devzkn on 12/10/2016.
//  Copyright © 2016 DevKevin. All rights reserved.
//

#import "DKTableViewController.h"
#import "DKMusicModel.h"
#import "UIImage+NJ.h"
#import "Colours.h"
#import "DKPlayingViewController.h"
#import "DKMusicTool.h"

@interface DKTableViewController ()

@property (nonatomic,strong) NSMutableArray *musicLsit;
@property (nonatomic,strong) DKPlayingViewController *playingViewController;



@end

@implementation DKTableViewController

- (DKPlayingViewController *)playingViewController{
    if (nil == _playingViewController) {
        DKPlayingViewController *tmpViewC = [[DKPlayingViewController alloc]init];
        _playingViewController = tmpViewC;
    }
    return _playingViewController;
}

- (NSMutableArray *)musicLsit{
    if (nil == _musicLsit) {
        NSMutableArray *tmp = [DKMusicTool musicModelList];
        _musicLsit = tmp;
    }
    return _musicLsit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"音乐播放器";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicLsit.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    DKMusicModel *model = self.musicLsit[indexPath.row];
    cell.imageView.image = [UIImage circleImageWithName:model.singerIcon borderWidth:1.0 borderColor:[UIColor skyBlueColor]];
    cell.textLabel.text = model.singer;
    cell.detailTextLabel.text = model.name;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //主动取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 设置当前播放的歌曲
    [DKMusicTool setPlayingMusic:self.musicLsit[indexPath.row]];
    //执行segue
//    [self performSegueWithIdentifier:@"Music2Playing" sender:nil];
    //自定义model。模仿，目的不让控制器dismiss的时候，销毁自己
    [self.playingViewController showVC];
    
}

@end
