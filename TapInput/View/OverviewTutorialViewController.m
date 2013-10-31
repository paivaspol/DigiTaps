//
//  TutorialViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/18/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "OverviewTutorialViewController.h"

#import "BackspaceGestureDetector.h"
#import "NaturalGestureDetector.h"

@interface OverviewTutorialViewController ()

@end

static NSString* const kTutorialStr = @"Practice";
static NSString* const kTitle = @"Overview";

@implementation OverviewTutorialViewController

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
  opvc = [[OverviewPracticeViewController alloc] init];
  GestureDetectorManager *manager = [[GestureDetectorManager alloc] init];
  [manager addGestureDetector:[[NaturalGestureDetector alloc] init]];
  [manager addGestureDetector:[[BackspaceGestureDetector alloc] init]];
  [opvc setGestureDetectorManager:manager];
  [super viewDidLoad];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:kTutorialStr
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(handleTutorialButton)];
  self.navigationItem.rightBarButtonItem = quitButton;
  [self setTitle:kTitle];
  CGRect infoViewSize = [self.infoView bounds];
  [self.scrollView setContentSize:CGSizeMake(infoViewSize.size.width, infoViewSize.size.height)];
  [self.scrollView addSubview:self.infoView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)handleTutorialButton
{
  [self.navigationController pushViewController:opvc animated:YES];
}


@end
