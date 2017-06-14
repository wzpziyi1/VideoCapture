//
//  ViewController.m
//  VideoCapture
//
//  Created by 王志盼 on 13/06/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化视频的输入&输出
    [self setupVideoInputOutput];
    
    //初始化音频的输入&输出
    [self setupAudioInputOutput];
    
}

- (void)setupVideoInputOutput
{
    //添加视频的输入
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *inputDevice;
    for (AVCaptureDevice *tmpDevice in devices)
    {
        if (tmpDevice.position == AVCaptureDevicePositionFront)
        {
            inputDevice = tmpDevice;
            break;
        }
    }
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if (error)
    {
        NSLog(@"%@", error);
        return;
    }
    
    //添加视频的输出
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    //在输出SampleBuffer的时候不要卡住主线程
    [self.videoOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
    
    //添加输入&&输出
    [self addInputOutputToSession:self.videoInput output:self.videoOutput];
}

- (void)setupAudioInputOutput
{
    
}

- (void)addInputOutputToSession:(AVCaptureDeviceInput *)input output:(AVCaptureVideoDataOutput *)output
{
    [self.session beginConfiguration];
    
    if ([self.session canAddInput:input])
    {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:output])
    {
        [self.session addOutput:output];
    }
    
    [self.session commitConfiguration];
}
#pragma mark - getter && setter

- (AVCaptureSession *)session
{
    if (!_session)
    {
        _session = [[AVCaptureSession alloc] init];
    }
    return  _session;
}

@end
