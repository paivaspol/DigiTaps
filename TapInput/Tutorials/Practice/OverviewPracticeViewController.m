//
//  OverviewPracticeViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 6/22/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "OverviewPracticeViewController.h"

#import "Utility.h"

static NSString * const kThreeFingersTap = @"Three finger tap";
static NSString * const kOneTap = @"One finger tap";
static NSString * const kTwoTap = @"Two fingers tap";
static NSString * const kSwipe = @"Swipe";
static NSString * const kTitle = @"Tutorial";
static NSString * const kBackspace = @"Backspace";
static NSString * const kLongPress = @"Long press";

@interface OverviewPracticeViewController ()

@end

@implementation OverviewPracticeViewController

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
  UIGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [self.view addGestureRecognizer:longPressRec];
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
  if (type == NATURAL) {
    switch (val) {
      case -1:
      case -2: {
        [self.description setText:kThreeFingersTap];
        [Utility announceVoiceOverWithString:kThreeFingersTap andValue:-1];
        break;
      }
      default:
        if (val == 1 || val == 4 || val == 7) {
          [self.description setText:kOneTap];
          [Utility announceVoiceOverWithString:kOneTap andValue:-1];
        } else if (val == 2 || val == 5 || val == 8) {
          [self.description setText:kTwoTap];
          [Utility announceVoiceOverWithString:kTwoTap andValue:-1];
        } else {
          [self.description setText:kSwipe];
          [Utility announceVoiceOverWithString:kSwipe andValue:-1];
        }
        break;
    }
  } else if (type == BACKSPACE) {
    [self.description setText:kBackspace];
    [Utility announceVoiceOverWithString:kBackspace andValue:-1];
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

- (void)handleLongPress:(UIGestureRecognizer *)recognizer
{
  [self.description setText:kLongPress];
  [Utility announceVoiceOverWithString:kLongPress andValue:-1];
}

@end
