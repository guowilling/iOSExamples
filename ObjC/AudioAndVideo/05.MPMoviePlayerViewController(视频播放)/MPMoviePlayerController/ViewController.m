
#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSURL *)getFileURL {
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"yindaoshipinios.mp4" ofType:nil];
    return [NSURL fileURLWithPath:urlStr];
}

- (NSURL *)getNetworkURL {
    
    NSString *urlStr = @"http://192.168.1.16/yindaoshipinios.mp4";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:urlStr];
}

- (MPMoviePlayerViewController *)moviePlayerViewController {

    if (!_moviePlayerViewController) {
        _moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[self getFileURL]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    }
    return _moviePlayerViewController;
}

- (IBAction)playClick:(UIButton *)sender {
    
    if (_moviePlayerViewController) {
        _moviePlayerViewController = nil;
    }
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}

- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放");
            break;
        default:
            NSLog(@"播放状态: %zd", self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification {
    
    NSLog(@"mediaPlayerPlaybackFinished");
    NSLog(@"播放状态: %zd", self.moviePlayerViewController.moviePlayer.playbackState);
}

@end
