//
//  GameCenterManager.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 4/14/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol GameCenterManagerProtocol <NSObject>
@optional
- (void)processGameCenterAuth:(NSError *)error;
- (void)scoreReported:(NSError *)error;
- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error;
- (void)achievementSubmitted:(GKAchievement *)ach error:(NSError *)error;
- (void)achievementResetResult:(NSError *)error;
- (void)mappedPlayerIDToPlayer:(GKPlayer *)player error:(NSError *)error;
@end

@interface GameCenterManager : NSObject
{
  id <GameCenterManagerProtocol> delegate;
}

@property (nonatomic, assign) id <GameCenterManagerProtocol> delegate;

// returns whether the game center is availiable or not
+ (BOOL) isGameCenterAvailable;
// authenticates the user
- (void) authenticateLocalUser;

// score related
- (void)reportScore:(int64_t)score forCategory:(NSString *)category;
- (void)reloadHighScoresForCategory:(NSString *)category;

@end
