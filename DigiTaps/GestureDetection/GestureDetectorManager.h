//
//  GestureDetector.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
//  Manages all the GestureDetectors. Provides a delegate to invoke when a gesture is detected
//  Backspace is always included.
//
//  The objects that wishes to use the GestureDetector should use this class to manage the
//  GestureDetectors.
//

#import <Foundation/Foundation.h>

#import "DTGestureDetector.h"
#import "GestureTypeUtility.h"
#import "DTGestureDetectionSharedState.h"

/*
 * Protocol for the object that uses this method to implement, so delegation works
 */
@protocol GestureDetectorManagerProtocol <NSObject>

/**
 * Implemented by the object that uses this object to perform the desired outcome.
 */
- (void)handleGesture:(GestureType)type withArgument:(NSInteger)arg;

@end

@interface GestureDetectorManager : NSObject <GestureDetectorProtocol>
{
  NSMutableArray *gestureDetectors;
  BOOL didDetectGesture;
}

@property (assign, nonatomic) id <GestureDetectorManagerProtocol> delegate;
/** The shared state across the gesture detectors */
@property (assign) GestureDetectorSharedState* sharedState;

/** Adds a gesture detector to the manager */
- (void)addGestureDetector:(GestureDetector *)detector;
/** Touch Began */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
/** Touch Moved */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
/** Touch Ended */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

- (void)setDidDetectGesture:(BOOL)didDetect;
/* resets the shared state property. */
- (void)reset;

@end
