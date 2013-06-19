//
//  GameInformationManager.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 4/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
//  Manages the underlying information of the game such as the player's id, accepted the agreement or not
//

#import <Foundation/Foundation.h>
#import "DataSender.h"

@interface GameInformationManager : NSObject
{
  @private
  DataSender *dataSender;
  CFNumberRef playerIdRef;
  int playerId;
}

// returns a singleton instance of the class
+ (id)getInstance;

// returns whether the user has already accepted the agreement or not
- (BOOL)didAgreeToAgreement;

// set the agreement preference
- (void)setAgreementPref:(BOOL)didAgree;

// returns the player's id, -1 if invalid
- (int)getPlayerId;

// generates the player, return the current playerId if the id has already been generated
// otherwise issue a request to the server, and return the newly requested id.
- (int)registerPlayer:(NSDictionary *)playerInformation;

@end
