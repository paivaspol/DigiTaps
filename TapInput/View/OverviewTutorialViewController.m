//
//  TutorialViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/18/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "OverviewTutorialViewController.h"

@interface OverviewTutorialViewController ()

@end

static NSString* const kMenuStr = @"Menu";
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
  [super viewDidLoad];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:kMenuStr
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(quitGameResponder)];
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

-(void)quitGameResponder
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
