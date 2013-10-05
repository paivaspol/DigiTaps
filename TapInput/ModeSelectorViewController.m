//
//  StartMenu.m
//  TapInput
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
  [self setTitle:@"Mode"];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)loadView
{
  self.view = [[[NSBundle mainBundle] loadNibNamed:@"ModeSelectorViewController" owner:self options:nil] lastObject];
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

- (IBAction)backButPressed:(id)sender
{

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
