//
//  Utility.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 6/20/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// returns the distance between the two given points.
+ (double)computeDistanceFrom:(CGPoint)pointOne to:(CGPoint)pointTwo;
// announce voiceover string, and checks if voiceover is running or not
+ (void)announceVoiceOverWithString:(NSString *)string andValue:(int)val;

// in iOS 7, presenting view controller modally is a pain because of the constraints.
// By wrapping the view controller inside a UINavigationController will help us with
// the constrait issue.
// + (UINavigationController *)addNavController:(UIViewController *) vc;
@end
