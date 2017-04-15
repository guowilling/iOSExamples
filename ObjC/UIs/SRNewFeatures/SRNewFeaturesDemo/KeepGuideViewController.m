
#import "KeepGuideViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface KeepGuideViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic, strong) AVAudioSession *avaudioSession;

@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *alpaView;
@property (weak, nonatomic) IBOutlet UIButton *regiset;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourViewLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridLabelWidth;
@end

@implementation KeepGuideViewController

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"KeepGuideVideo.mp4" ofType:nil];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
    [_moviePlayer.view setFrame:self.view.bounds];
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setFullscreen:YES];
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateDidChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    
    _alpaView.backgroundColor = [UIColor clearColor];
    [_moviePlayer.view addSubview:_alpaView];
    
    self.regiset.layer.cornerRadius = 3.0f;
    self.regiset.alpha = 0.4f;
    
    self.login.layer.cornerRadius = 3.0f;
    self.login.alpha = 0.4f;
    
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setupTimer];
}

- (void)moviePlayerPlaybackStateDidChange {
    
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [_moviePlayer play];
            break;
        case MPMoviePlaybackStatePlaying:
            break;
        case MPMoviePlaybackStatePaused:
            [_moviePlayer play];
            break;
        case MPMoviePlaybackStateInterrupted:
            break;
        case MPMoviePlaybackStateSeekingForward:
            break;
        case MPMoviePlaybackStateSeekingBackward:
            break;
        default:
            break;
    }
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    self.viewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 4;
    self.secondViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self.thirdViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    self.fourViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 3;
    self.firstLabelWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self.secondLabelWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.thridLabelWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (void)setupTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)update {
    
    int page = (self.pageControl.currentPage + 1) % 4;
    self.pageControl.currentPage = page;
    [self pageChanged:self.pageControl];
}

- (void)pageChanged:(UIPageControl *)pageControl {
    
    CGFloat x = (pageControl.currentPage) * [UIScreen mainScreen].bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    double page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
    if (page == - 1) {
        self.pageControl.currentPage = 3;
    } else if (page == 4) {
        self.pageControl.currentPage = 0;
        //[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self setupTimer];
}

@end
