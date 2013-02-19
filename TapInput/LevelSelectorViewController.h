//
//  LevelSelectorViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/9/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelSelectorView.h"

@protocol LevelSelectorProtocol <NSObject>

- (void)startLevel:(int)level;

@end

@interface LevelSelectorViewController : UIViewController<LevelSelectorViewProtocol> {
  NSInteger curLevels;
}

@property (assign, nonatomic) id <LevelSelectorProtocol> delegate;

- (id)initWithNumLevels:(NSInteger)levels;

@end
