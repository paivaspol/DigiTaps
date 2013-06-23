//
//  LevelSelectorView.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "LevelSelectorView.h"

@implementation LevelSelectorView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor grayColor]];
    [self drawButtons];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame andNumLevels:(NSInteger)numLevel
{
  numLevels = numLevel;
  return [self initWithFrame:frame];
}

- (void)drawButtons
{
  int initialRowOffset = 30, initialColOffset = 12;
  for (int i = 0; i < numLevels; i++) {
    int col = i % 3, row = i / 3;
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(0, 0, 70, 70)];
    [but setCenter:CGPointMake(initialColOffset + (col * 100) + 50, initialRowOffset + (row * 100) + 50)];
    [but setTag:i + 1];
    [but setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(levelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: but];
  }
}

- (void)levelSelected:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(startLevel:)]) {
    UIButton *but = (UIButton *)sender;
    [self.delegate startLevel:[but tag]];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
