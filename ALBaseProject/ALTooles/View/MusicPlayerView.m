//
//  MusicPlayerView.m
//  Linke
//
//  Created by noodle on 25/2/17.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "MusicPlayerView.h"

@interface MusicPlayerView ()
{
    
}

@property (nonatomic, assign) FSStreamPosition pauseTime;
@property (nonatomic, assign) FSSeekByteOffset seekByteOffset;

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation MusicPlayerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 2, 40, 40)];
        [self.playButton setImage:[UIImage imageNamed:@"knowledge_play_icon"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"knowledge_stop_icon"] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(58, 36, frame.size.width-20-48, 2)];
        self.line.backgroundColor = [UIColor blackColor];
        [self addSubview:self.line];
        self.progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 2)];
        self.progressView.backgroundColor = RGB(241, 172, 47);
        [self.line addSubview:self.progressView];
        self.circleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.circleView.backgroundColor = RGB(241, 172, 47);
        self.circleView.layer.cornerRadius = self.circleView.width/2;
        [self.progressView addSubview:self.circleView];
        self.circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.circleView.centerY = self.progressView.height/2;
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 60, 15, 50, 12)];
        self.time.text = @"00:00";
        [self addSubview:self.time];
    }
    return self;
}


-(void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    self.progressView.width = progressValue*self.line.width;
}

-(void)setupWithUrl:(NSString*)url
{
    _audioStream=[[FSAudioStream alloc]initWithUrl:[NSURL URLWithString:url]];
    _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
        NSLog(@"播放过程中发生错误，错误信息：%@",description);
    };
    __weak MusicPlayerView *weakself = self;
    _audioStream.onCompletion=^(){
        weakself.completion();
    };
    [_audioStream setVolume:1];
}

- (void)playButtonDidTap:(UIButton*)button{
    if (self.playButton.isSelected) {
        
        [self pause];
    }else{
        [self play];
    }
    self.playButton.selected = !self.playButton.isSelected;
}

-(void)play
{
    
    [_audioStream play];
    //[_audioStream playFromOffset:self.seekByteOffset];
    //FSSeekByteOffset offset;
    //self.seekByteOffset = offset;
    
    
    [_progressTimer invalidate];
    _progressTimer = nil;
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
}

-(void)pause
{
    //self.seekByteOffset = _audioStream.currentSeekByteOffset;
    
    [_audioStream pause];
    [_progressTimer invalidate];
    _progressTimer = nil;
    self.time.text = [self timeFormatted:0];
    [self setProgressValue:0];
}

-(void)moveProgress
{
    self.time.text = [self timeFormatted:_audioStream.currentTimePlayed.playbackTimeInSeconds];
    
    CGFloat progressValue = 0;
    if (_audioStream.duration.playbackTimeInSeconds > 0) {
        progressValue = _audioStream.currentTimePlayed.playbackTimeInSeconds/_audioStream.duration.playbackTimeInSeconds;
    }
    
    [self setProgressValue:progressValue];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
