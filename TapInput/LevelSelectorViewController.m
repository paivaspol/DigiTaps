//
//  LevelSelectorViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/9/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "LevelSelectorViewController.h"

@interface LevelSelectorViewController ()

@end

@implementation LevelSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithNumLevels:(NSInteger)levels
{
  curLevels = levels;
  [self setTitle:@"Select level"];
  
  return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Select a level");
}

- (void)loadView
{
  LevelSelectorView *lsv = [[LevelSelectorView alloc] initWithFrame:[[UIScreen mainScreen] bounds] andNumLevels:curLevels];
  self.view = lsv;
  [lsv setDelegate:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)startLevel:(int)level
{
  if ([self.delegate respondsToSelector:@selector(startLevel:)]) {
    [self.delegate startLevel:level];
  }
}

@end
