//
//  StartMenu.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "ModeSelectorViewController.h"

@interface ModeSelectorViewController ()

@end

@implementation ModeSelectorViewController

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
  [self setTitle:@"Select Mode"];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self setUpViewForOrientation:interfaceOrientation];
}

- (IBAction)buttonPressed:(id)sender
{
  UIButton *but = (UIButton *) sender;
  if (but.tag == 0) {
    if ([self.delegate respondsToSelector:@selector(startGameWithNaturalMode:)]) {
      [self.delegate startGameWithNaturalMode:YES];
    }
  } else {
    if ([self.delegate respondsToSelector:@selector(startGameWithNaturalMode:)]) {
      [self.delegate startGameWithNaturalMode:NO];
    }
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
//  [_currentView removeFromSuperview];
//  if (UIInterfaceOrientationIsLandscape(orientation)) {
//    if (![self.view isEqual:_landscapeView]) {
//      [self.view addSubview:_landscapeView];
//      _landscapeView.frame = self.view.bounds;
//      _currentView = _landscapeView;
//      [self.view setNeedsLayout];
//    }
//  } else {
//    if (![self.view isEqual:_portraitView]) {
//      [self.view addSubview:_portraitView];
//      _portraitView.frame = self.view.bounds;
//      _currentView = _portraitView;
//      [self.view setNeedsLayout];
//    }
//  }
}

@end
