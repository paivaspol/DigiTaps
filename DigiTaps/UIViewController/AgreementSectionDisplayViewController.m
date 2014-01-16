//
//  AgreementSectionDisplayViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/8/14.
//  Copyright (c) 2014 MobileAccessibility. All rights reserved.
//

#import "AgreementSectionDisplayViewController.h"
#import "SVProgressHUD.h"

@interface AgreementSectionDisplayViewController ()
{
  NSArray *sectionName;
}

@end

@implementation AgreementSectionDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    sectionName = @[ @"overview", @"purpose", @"benefits", @"procedures", @"risks", @"other", @"contact" ];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // load the content of the view from a file based on the section specified.
  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
  NSString *path = [[NSBundle mainBundle] pathForResource:[sectionName objectAtIndex:self.agreementSection] ofType:@"txt"];
  NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//  CGRect screenRect = [[UIScreen mainScreen] bounds];
//  CGFloat screenWidth = screenRect.size.width;
  [self.contentView setText:content];
  [self.contentView setNumberOfLines:0];
//  [self.contentView sizeToFit];
  NSString *title = [sectionName objectAtIndex:self.agreementSection];
  [self setTitle:[title capitalizedString]];
  [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
