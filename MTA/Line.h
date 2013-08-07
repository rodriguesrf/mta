//
//  Line.h
//  MTA
//
//  Created by Renata Rodrigues on 7/30/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StatusGood,
    StatusDelay,
    StatusPlannedWork,
} LineStatus;

@interface Line : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) LineStatus status;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;

+ (LineStatus)statusForString:(NSString *)statusString;

@end
