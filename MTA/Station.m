//
//  Station.m
//  MTA
//
//  Created by Renata Rodrigues on 7/30/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "Station.h"

@implementation Station

-(NSString *)description
{
    return [NSString stringWithFormat:@"division:%@| line:%@| stationName:%@| lat:%@| lon:%@, route: %@, entry:%@",self.division, self.line, self.stationName, self.latitude, self.longitude, self.route, self.entry
           ];
}

@end
