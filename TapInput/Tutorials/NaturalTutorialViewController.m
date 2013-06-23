//
//  NaturalTutorialViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "NaturalTutorialViewController.h"

#import "NaturalGestureDetector.h"

@interface NaturalTutorialViewController ()

@end

static NSString * const kTutorialStr = @"Practice";
static NSString * const kTitle = @"Natural";


@implementation NaturalTutorialViewController

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
  npvc = [[NaturalPracticeViewController alloc] init];
  GestureDetectorManager *manager = [[GestureDetectorManager alloc] init];
  [manager addGestureDetector:[[NaturalGestureDetector alloc] init]];
  [npvc setGestureDetectorManager:manager];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:kTutorialStr
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(handlePracticeButton)];
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

-(void)handlePracticeButton
{
  [self.navigationController pushViewController:npvc animated:YES];
}

@end
