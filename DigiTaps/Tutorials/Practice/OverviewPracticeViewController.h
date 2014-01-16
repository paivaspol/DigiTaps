//
//  OverviewPracticeViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 6/22/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../../GestureDetection/GestureDetectorManager.h"

@interface OverviewPracticeViewController : UIViewController <GestureDetectorManagerProtocol>
{
  GestureDetectorManager *gestureDetectorManager;
  UILongPressGestureRecognizer *longPressRecognizer;
}
@property (strong, nonatomic) IBOutlet UILabel *description;

- (void)setGestureDetectorManager:(GestureDetectorManager *)manager;

@end