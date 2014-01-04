//
//  TutorialViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "TutorialViewController.h"

#import "OverviewTutorialViewController.h"
#import "DTCappuccinoTutorialViewController.h"
#import "DTEspressoTutorialViewController.h"

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
    DTEspressoTutorialViewController *ntvc = [[DTEspressoTutorialViewController alloc] init];
    [self.navigationController pushViewController:ntvc animated:YES];
  } else {
    DTCappuccinoTutorialViewController *lntvc = [[DTCappuccinoTutorialViewController alloc] init];
    [self.navigationController pushViewController:lntvc animated:YES];
  }
}

@end
