
#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSURL *)getFileURL {
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"jieshaoshiping.mp4" ofType:nil];
    return [NSURL fileURLWithPath:urlStr];
}

- (NSURL *)getNetworkURL {
    NSString *urlStr = @"http://192.168.1.16/jieshaoshiping.mp4";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:urlStr];
}

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[self getFileURL]];
        _moviePlayerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //_moviePlayerController.controlStyle = MPMovieControlStyleNone;
        _moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.moviePlayerController play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayerController];
    
    [self.moviePlayerController requestThumbnailImagesAtTimes:@[@1.0, @5.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.moviePlayerController.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放.");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态: %zd", self.moviePlayerController.playbackState);
            break;
    }
}

- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification {
    NSLog(@"mediaPlayerPlaybackFinished");
    NSLog(@"播放状态: %zd", self.moviePlayerController.playbackState);
}

- (void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification {
    NSLog(@"视频截图完成!");
    UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)playWithAVPlayer {
    AVPlayer *player = [AVPlayer playerWithURL:[self getFileURL]];
    AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
    playerLayer.player = player;
    playerLayer.frame = CGRectMake(0, 0, 299, 199);
    [self.view.layer addSublayer:playerLayer];
    [player play];
}

@end
