//
//  Line.m
//  MTA
//
//  Created by Renata Rodrigues on 7/30/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "Line.h"

@implementation Line

+ (LineStatus)statusForString:(NSString *)statusString
{
    LineStatus status = StatusGood;
    if([statusString isEqualToString:@"PLANNED WORK"]) {
        status = StatusPlannedWork;
    } else if([statusString isEqualToString:@"DELAYS"]) {
        status = StatusDelay;
    }
    return status;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@|date:%@|time:%@|status:%d", self.name, self.date, self.time, self.status];
}

@end
