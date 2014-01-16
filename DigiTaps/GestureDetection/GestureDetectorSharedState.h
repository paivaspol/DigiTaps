//
//  GestureDetectorSharedStateProtocol.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 11/15/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
//  Abstract class the shared state of the gesture detectors.
//  See DTGestureDetectorSharedState for how it is used.
//

#import <Foundation/Foundation.h>

@protocol GestureDetectorSharedStateProtocol <NSObject>

@required

/* Resets all the field in this shared state object. */
- (void)reset;

@end

@interface GestureDetectorSharedState : NSObject<GestureDetectorSharedStateProtocol>

- (void)reset;

@end
