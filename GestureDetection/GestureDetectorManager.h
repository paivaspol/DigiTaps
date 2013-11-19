//
//  GestureDetector.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
//  Manages all the GestureDetectors. Provides a delegate to invoke when a gesture is detected
//  Backspace is always included.
//

#import <Foundation/Foundation.h>

#import "DTGestureDetector.h"
#import "GestureTypeUtility.h"
#import "DTGestureDetectionSharedState.h"


@protocol GestureDetectorManagerProtocol <NSObject>

- (void)handleGesture:(GestureType)type withArgument:(NSInteger)arg;

@end

@interface GestureDetectorManager : NSObject <GestureDetectorProtocol>
{
  NSMutableArray *gestureDetectors;
  BOOL didDetectGesture;
}

@property (assign, nonatomic) id <GestureDetectorManagerProtocol> delegate;
@property (assign) GestureDetectorSharedState* sharedState;

- (void)addGestureDetector:(GestureDetector *)detector;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

- (void)setDidDetectGesture:(BOOL)didDetect;
/* resets the shared state property. */
- (void)reset;

@end
