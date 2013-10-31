//
//  LessNaturalTutorialViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "LessNaturalTutorialViewController.h"

#import "LessNaturalGestureDetector.h"

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
  [manager addGestureDetector:[[LessNaturalGestureDetector alloc] init]];
  [lnpvc setGestureDetectorManager:manager];
  [super viewDidLoad];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:kTutorialStr
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(tutorialButtonHandler)];
  self.navigationItem.rightBarButtonItem = quitButton;
  [self setTitle:kTitle];
  CGRect infoViewSize = [self.infoView bounds];
  [self.scrollView setContentSize:CGSizeMake(infoViewSize.size.width, infoViewSize.size.height)];
  [self.scrollView addSubview:self.infoView];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)tutorialButtonHandler
{
  [self.navigationController pushViewController:lnpvc animated:YES];
}


@end
