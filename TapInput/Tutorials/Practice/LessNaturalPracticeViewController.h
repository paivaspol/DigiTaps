//
//  LessNaturalPracticeViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 6/22/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GestureDetectorManager.h"
#import "Utility.h"

@interface LessNaturalPracticeViewController : UIViewController <GestureDetectorManagerProtocol>
{
  GestureDetectorManager *gestureDetectorManager;
}

@property (strong, nonatomic) IBOutlet UILabel *description;

- (void)setGestureDetectorManager:(GestureDetectorManager *)manager;

@end
