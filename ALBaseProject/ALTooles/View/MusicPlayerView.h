//
//  MusicPlayerView.h
//  Linke
//
//  Created by noodle on 25/2/17.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAudioStream.h"
@interface MusicPlayerView : UIView
@property (assign,nonatomic) CGFloat progressValue;
@property (strong,nonatomic) UIView *circleView;
@property (strong,nonatomic) UIView *line;
@property (strong,nonatomic) UIView *progressView;
@property (strong,nonatomic) UILabel *time;
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (copy,nonatomic) void(^completion)(void);
-(void)setupWithUrl:(NSString*)url;
-(void)play;
-(void)pause;
@end
