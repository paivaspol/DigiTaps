//
//  GestureDetector.h
//  DigiTaps
//
//  An interface for detecting gestures.
//  NO instace should be created from this class
//
//  Created by Vaspol Ruamviboonsuk on 11/18/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GestureDetectorProtocol <NSObject>

/** 
 *  Callback method when a gesture is detected.
 *  For example, when the touchEnded is called, this method will be called.
 *  touchEnded should provide the correct interpretation of the gesture.
 *  
 *  Args: gesture - the name of the gesture
 *        arg - optional arguments (in our specific case just the number of fingers)
 */
- (void)gestureDetectedAs:(NSString *)gesture withArgument:(NSInteger)arg;

@end

/**
 *  Protocol to make sure that these three methods are implemented by the subclass
 *  This is a mirror of what iOS offers. Each method does exactly what iOS method does.
 */
@protocol GestureDetectorHandlerProtocol <NSObject>

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
- (void)touchMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

@end

@interface GestureDetector : NSObject <GestureDetectorHandlerProtocol>

@property (strong, nonatomic) id <GestureDetectorProtocol> delegate;

@end