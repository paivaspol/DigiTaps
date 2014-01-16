//
//  UserAgreementViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

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
  // Do any additional setup after loading the view from its nib.
  agreementDisplay = [[AgreementSectionDisplayViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row <= 6) {
    // From overview to contact
    [agreementDisplay setAgreementSection:indexPath.row];
    [self.navigationController pushViewController:agreementDisplay animated:YES];
  } else if (indexPath.row == 8) {
    if (self.showedModally) {
      // Agree
      if ([self.delegate respondsToSelector:@selector(agreed)]) {
        [self.delegate agreed];
      }
    } else {
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
}

@end
