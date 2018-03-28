

#import "AudioPlayerManager.h"

static AudioPlayerManager *static_audioPlayerManage = nil;

@implementation AudioPlayerManager

@synthesize audioPlayer = _audioPlayer;

+ (AudioPlayerManager*)shareInstance
{
    @synchronized(self){
        if ( nil == static_audioPlayerManage ) {
            static_audioPlayerManage = [[AudioPlayerManager alloc] init];
        }
    }
    
    return static_audioPlayerManage;
}

+(void)destroyInstance
{

    if (static_audioPlayerManage) {
        [static_audioPlayerManage stop];
        static_audioPlayerManage = nil;
    }

}

- (id) init
{
    self = [super init];
    
    if (self ) {
        
        
    }
    
    return self;
}

- (void)player:(NSString*) filename
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    NSString *strPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSURL *url = [NSURL fileURLWithPath:strPath];
    NSError *outError = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&outError];
    
    player.numberOfLoops = 0;
    player.currentTime = 0.0;
    player.delegate = self;
    self.audioPlayer = player;
    [self.audioPlayer play];
  
}

- (void)repeatPlay:(NSString *)filename {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString *strPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSURL *url = [NSURL fileURLWithPath:strPath];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;
    player.currentTime = 0.0;
    player.delegate = self;
    self.audioPlayer = player;
    [self.audioPlayer play];
 }


- (void)stop {
    self.audioPlayer.delegate = nil;
    [self.audioPlayer stop];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *) _player successfully:(BOOL)flag
{
    self.audioPlayer.delegate = nil;
    [self.audioPlayer stop];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

-(void)playSystemSoundWithSystemoSoundId:(SystemSoundID)systemSoudId;
{
    AudioServicesPlaySystemSound(systemSoudId);
}

//震动
-(void)playVibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/*
 @discussion
 * 1、播放的时间不能超过30秒
 * 2、数据必须是 PCM或者IMA4流格式
 * 3、必须被打包成下面三个格式之一：Core Audio Format (.caf), Waveform audio (.wav), 或者 Audio Interchange File (.aiff)
 */
+ (void)playSoundWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"Error: audio file not found at path: %@", path);
    }
}


- (void)dealloc
{
    _audioPlayer.delegate = nil;
    [_audioPlayer stop];
}

@end
