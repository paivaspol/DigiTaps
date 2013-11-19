//
//  LevelSelectorView.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LevelSelectorViewProtocol <NSObject>

- (void)startLevel:(int)level;

@end

@interface LevelSelectorView : UIView
{
  NSInteger numLevels;
}

@property (assign, nonatomic) id <LevelSelectorViewProtocol> delegate;

- (id)initWithFrame:(CGRect)frame andNumLevels:(NSInteger)numLevel;

@end