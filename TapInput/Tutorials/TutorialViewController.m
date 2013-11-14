//
//  TutorialViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "TutorialViewController.h"

#import "OverviewTutorialViewController.h"
#import "LessNaturalTutorialViewController.h"
#import "NaturalTutorialViewController.h"

@interface TutorialViewController ()

@end

static NSString * const kTitle = @"Tutorial";

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:kTitle];
  
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self setUpViewForOrientation:interfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)handleButton:(id)sender {
  UIButton *but = (UIButton *)sender;
  if ([but tag] == 0) {
    OverviewTutorialViewController *otvc = [[OverviewTutorialViewController alloc] init];
    [self.navigationController pushViewController:otvc animated:YES];
  } else if ([but tag] == 1) {
    NaturalTutorialViewController *ntvc = [[NaturalTutorialViewController alloc] init];
    [self.navigationController pushViewController:ntvc animated:YES];
  } else {
    LessNaturalTutorialViewController *lntvc = [[LessNaturalTutorialViewController alloc] init];
    [self.navigationController pushViewController:lntvc animated:YES];
  }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
  [_currentView removeFromSuperview];
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    if (![self.view isEqual:_landscapeView]) {
      [self.view addSubview:_landscapeView];
      _landscapeView.frame = self.view.bounds;
      _currentView = _landscapeView;
      [self.view setNeedsLayout];
    }
  } else {
    if (![self.view isEqual:_portraitView]) {
      [self.view addSubview:_portraitView];
      _portraitView.frame = self.view.bounds;
      _currentView = _portraitView;
      [self.view setNeedsLayout];
    }
  }
}
@end
