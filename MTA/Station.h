//
//  Station.h
//  MTA
//
//  Created by Renata Rodrigues on 7/30/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, strong) NSString *division;
@property (nonatomic, strong) NSString *line;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSMutableArray *route;
@property (nonatomic, strong) NSString *entry;

@end
