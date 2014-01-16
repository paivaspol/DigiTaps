//
//  LogSenderOperation.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 4/15/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../Logging/Logger.h"  // for logger to send over
#import "../Networking/DataSender.h"  // for sending data over across the network

@interface LogSenderOperation : NSOperation
{
  DataSender *dataSender;
  Logger *logger;
}

@end
