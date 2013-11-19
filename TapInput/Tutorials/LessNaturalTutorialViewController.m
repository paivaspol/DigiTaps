//
//  LessNaturalTutorialViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "LessNaturalTutorialViewController.h"

#import "DTCappuccinoGestureDetector.h"

@interface LessNaturalTutorialViewController ()

@end

static NSString* const kTutorialStr = @"Practice";
static NSString* const kTitle = @"Less Natural";

@implementation LessNaturalTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  lnpvc = [[LessNaturalPracticeViewController alloc] init];
  GestureDetectorManager *manager = [[GestureDetectorManager alloc] init];
  [manager addGestureDetector:[[DTCappuccinoGestureDetector alloc] init]];
  [lnpvc setGestureDetectorManager:manager];
  [super viewDidLoad];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:kTutorialStr
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(tutorialButtonHandler)];
  self.navigationItem.rightBarButtonItem = quitButton;
  [self setTitle:kTitle];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self setUpViewForOrientation:interfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)tutorialButtonHandler
{
  [self.navigationController pushViewController:lnpvc animated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
  [_currentView removeFromSuperview];
  CGFloat width = [[UIScreen mainScreen] bounds].size.height;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    if (![self.view isEqual:_landscape35InfoView] && width == 480.0) {
      [self.scrollView addSubview:_landscape35InfoView];
      _currentView = _landscape35InfoView;
    } else if (![self.view isEqual:_landscape4InfoView] && width == 568.0) {
      [self.scrollView addSubview:_landscape4InfoView];
      _currentView = _landscape4InfoView;
    }
  } else {
    if (![self.view isEqual:_portraitView]) {
      [self.scrollView addSubview:_portraitView];
      _currentView = _portraitView;
    }
  }
  CGRect infoViewSize = [_currentView bounds];
  [self.scrollView setContentSize:CGSizeMake(infoViewSize.size.width, infoViewSize.size.height)];
}

@end
