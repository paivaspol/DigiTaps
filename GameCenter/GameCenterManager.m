//
//  GameCenterManager.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 4/14/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "GameCenterManager.h"

@interface GameCenterManager()

@end

@implementation GameCenterManager

+ (BOOL)isGameCenterAvailable
{
  // check for presence of GKLocalPlayer API
  Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
  
  // check if the device is running iOS 4.1 or later
  NSString *reqSysVer = @"4.1";
  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  
  return (gcClass && osVersionSupported);
}

- (void)authenticateLocalUser
{
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  if(localPlayer.authenticated == NO) {
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
      if (viewController != nil) {
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:viewController animated:YES completion:nil];
      } else {
        [self checkLocalPlayer];
      }
    };
  } 
}

- (void)checkLocalPlayer {
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  if (localPlayer.isAuthenticated) {
    // this is called when the player successfully authenticated
    // call the delegate selector to handle this case
    [self callDelegate:@selector(processGameCenterAuth:) withArg:nil error:nil];
  }
}


/**
 *  Helpers for calling delegate methods on the main queue
 *  This is necessary because GameCenter doesn't guarantee that code will be executed on the main thread.
 */
- (void) callDelegate:(SEL)selector withArg:(id)arg error:(NSError*)err
{
  assert([NSThread isMainThread]);
  if([delegate respondsToSelector: selector]) {
    if(arg != NULL) {
      [delegate performSelector:selector withObject:arg withObject:err];
    } else {
      [delegate performSelector:selector withObject:err];
    }
  } else {
    NSLog(@"Missed Method");
  }
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
  dispatch_async(dispatch_get_main_queue(), ^(void)
  {
    [self callDelegate: selector withArg: arg error: err];
  });
}

#pragma mark score reporting
+ (void)reportScore:(int64_t)score forCategory:(NSString *)category
{
  double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
  double eps = 10e-6;
  if ((fabs(systemVersion - 6.0) < eps || systemVersion > 6.0) && systemVersion < 7.0) {
    // this is version between 6.x
      GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
      scoreReporter.value = score;
      scoreReporter.context = 0;
      
      [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
      }];
  } else if (fabs(systemVersion - 7.0) < eps || systemVersion > 7.0) {
    // version greater than 7.0
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
      NSLog(@"score reported");
    }];
  }
}

@end
