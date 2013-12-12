//
//  LessNaturalPracticeViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 6/22/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DTCappuccinoPracticeViewController.h"

#import "DTCappuccinoGestureDetector.h"

static NSString * const kThreeFingersTap = @"Three finger tap. Waiting for another gesture";
static NSString * const kSwipeWaiting = @"Swipe. Waiting for another gesture";
static NSString * const kOneTap = @"One finger tap. %d";
static NSString * const kTwoTap = @"Two fingers tap. %d";
static NSString * const kSwipe = @"Swipe. %d";
static NSString * const kTitle = @"Tutorial";

@interface DTCappuccinoPracticeViewController ()

@end

@implementation DTCappuccinoPracticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

/**
 *  Sets the gesture detector manager with the manager being passed in
 */
- (void)setGestureDetectorManager:(GestureDetectorManager *)manager
{
  gestureDetectorManager = manager;
  [gestureDetectorManager setDelegate:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:kTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.view setIsAccessibilityElement:YES];
  [self.view setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
  [self.view becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark gesture detector protocol
- (void)handleGesture:(GestureType)type withArgument:(NSInteger)arg
{
  NSInteger val = arg;
  if (type == LESS_NATURAL) {
    switch (val) {
      case -1: {
        [self.description setText:kThreeFingersTap];
        [Utility announceVoiceOverWithString:kThreeFingersTap andValue:val];
        break;
      }
      case -2: {
        [self.description setText:kSwipeWaiting];
        [Utility announceVoiceOverWithString:kSwipeWaiting andValue:val];
        break;
      }
      default:
        if (val == 1 || val == 4 || val == 7) {
          [self.description setText:[NSString stringWithFormat:kOneTap, val]];
          [Utility announceVoiceOverWithString:kOneTap andValue:val];
        } else if (val == 2 || val == 5 || val == 8) {
          [self.description setText:[NSString stringWithFormat:kTwoTap, val]];
          [Utility announceVoiceOverWithString:kTwoTap andValue:val];
        } else {
          [self.description setText:[NSString stringWithFormat:kSwipe, val]];
          [Utility announceVoiceOverWithString:kSwipe andValue:val];
        }
        break;
    }
  }
}

#pragma mark touch handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [gestureDetectorManager touchesBegan:touches withEvent:event inView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [gestureDetectorManager touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [gestureDetectorManager touchesEnded:touches withEvent:event inView:self.view];
}

@end