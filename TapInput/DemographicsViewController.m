//
//  DemographicsViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 3/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DemographicsViewController.h"

@interface DemographicsViewController ()

@end

@implementation DemographicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self.scrollView addSubview:self.demographicsView];
    [self setTitle:@"Demographics"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(registerCompletedWithUserId:)]) {
    // registers the player with the server
    GameInformationManager *gameInfoManager = [GameInformationManager getInstance];
    [SVProgressHUD showWithStatus:@"Registering..." maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dummy = [[NSMutableDictionary alloc] init];
    [dummy setValue:@"dummyValue" forKey:@"DummyKey"];
    int playerId = [gameInfoManager registerPlayer:dummy];
    [SVProgressHUD dismiss];
    NSLog(@"playerId: %d", playerId);
    [self.delegate registerCompletedWithUserId:playerId];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
