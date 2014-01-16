//
//  TutorialViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "TutorialViewController.h"

#import "AboutViewController.h"
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
  UIViewController *viewController = nil;
  if ([but tag] == 0) {
    viewController = [[OverviewTutorialViewController alloc] init];
  } else if ([but tag] == 1) {
    viewController = [[DTEspressoTutorialViewController alloc] init];
  } else if ([but tag] == 2) {
    viewController = [[DTCappuccinoTutorialViewController alloc] init];
  } else if ([but tag] == 3) {
    // Load the about page
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
  }
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
