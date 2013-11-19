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

- (void)gestureDetectedAs:(NSString *)gesture withArgument:(NSInteger)arg;

@end

@protocol GestureDetectorHandlerProtocol <NSObject>

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
- (void)touchMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

@end

@interface GestureDetector : NSObject <GestureDetectorHandlerProtocol>

@property (strong, nonatomic) id <GestureDetectorProtocol> delegate;

@end