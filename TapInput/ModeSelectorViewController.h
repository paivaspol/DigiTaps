//
//  StartMenu.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 1/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModeSelectorProtocol;

@interface ModeSelectorViewController : UIViewController {

}

@property (strong, nonatomic) IBOutlet UIButton *natural;
@property (strong, nonatomic) IBOutlet UIButton *lessNatural;
@property (assign, nonatomic) id <ModeSelectorProtocol> delegate;

- (IBAction)buttonPressed:(id)sender;

@end

@protocol ModeSelectorProtocol <NSObject>

- (void)startGameWithNaturalMode:(BOOL)isNatural;

@end