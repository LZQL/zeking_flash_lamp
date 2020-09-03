#import "ZekingFlashLampPlugin.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZekingFlashLampPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zeking_flash_lamp"
            binaryMessenger:[registrar messenger]];
  ZekingFlashLampPlugin* instance = [[ZekingFlashLampPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
    if ([@"turnOn" isEqualToString:call.method]) {
       NSNumber *intensity = call.arguments[@"intensity"];
       [self turnOnWithIntensity:intensity.doubleValue];
       result(nil);
    }
     else if ([@"turnOff" isEqualToString:call.method]) {
         [self turnOff];
         result(nil);
      }
     else if ([@"hasLamp" isEqualToString:call.method]) {
         result([NSNumber numberWithBool:[self hasLamp]]);
     }
    else {
      result(FlutterMethodNotImplemented);
    }
}

// 检测是否有闪光灯
- (bool) hasLamp
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return ([device hasTorch] && [device hasFlash]);
}

// 关闭闪光灯
- (void) turnOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

// 打开闪光灯
- (void)turnOnWithIntensity:(float)level
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        NSError *error = nil;
        float acceptedLevel = (level < AVCaptureMaxAvailableTorchLevel ? level : AVCaptureMaxAvailableTorchLevel);
        NSLog(@"FLash level: %f", acceptedLevel);
        [device setTorchModeOnWithLevel:acceptedLevel error:&error];
        [device unlockForConfiguration];
    }
}


@end
