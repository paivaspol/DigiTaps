//
//  GameInformationManager.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 4/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameInformationManager.h"

static CFStringRef showAgreementKey = CFSTR("didAgree");
static CFStringRef playerIdKey = CFSTR("playerId");
static NSString *kUrl = @"http://digitap.cs.washington.edu/register_postgres.php";

@implementation GameInformationManager

+ (id)getInstance
{
  static GameInformationManager *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[GameInformationManager alloc] init];
  });
  return instance;
}

- (id)init
{
  if ((self = [super init]) != nil) {
    playerId = [self getPlayerId];
    dataSender = [[DataSender alloc] init];
  }
  return self;
}

// returns whether the user has already accepted the agreement or not
- (BOOL)didAgreeToAgreement
{
  Boolean retval;
  if (!CFPreferencesGetAppBooleanValue(showAgreementKey, kCFPreferencesCurrentApplication, &retval)) {
    retval = false;
  }
  return retval;
}

// set the agreement preference
- (void)setAgreementPref:(BOOL)didAgree
{
  if (didAgree) {
    CFPreferencesSetAppValue(showAgreementKey, kCFBooleanTrue, kCFPreferencesCurrentApplication);
  } else {
    CFPreferencesSetAppValue(showAgreementKey, kCFBooleanFalse, kCFPreferencesCurrentApplication);
  }
}

// returns the player's id, -1 if invalid.
- (int)getPlayerId
{
  if (playerId > 0) {
    return playerId;
  }
  playerIdRef = (CFNumberRef)CFPreferencesCopyAppValue(playerIdKey, kCFPreferencesCurrentApplication);
  if (playerIdRef) {
    if (!CFNumberGetValue(playerIdRef , kCFNumberIntType, &playerId)) {
        playerId = -1;
    }
  }
  return playerId;
}

- (int)registerPlayer:(NSDictionary *)playerInformation
{
  NSString *newId;
  if ([dataSender sendData:playerInformation toURL:[NSURL URLWithString:kUrl] andReceived:&newId]) {
    playerId = [newId integerValue];
  }
  playerIdRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &playerId);
  CFPreferencesSetAppValue(playerIdKey, playerIdRef, kCFPreferencesCurrentApplication);
  CFRelease(playerIdRef);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRegistered" object:self userInfo:nil];
  return playerId;
}

@end
