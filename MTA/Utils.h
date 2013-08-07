//
//  Utils.h
//  MTA
//
//  Created by Renata Rodrigues on 8/1/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface Utils : NSObject

+ (NSString *)trainToLineName:(NSString *)train;
+ (int)findLineInArray:(NSArray *)lines forLineName:(NSString *)lineName;
+ (NSString *)statusNumberToSentence:(int)status;
@end
