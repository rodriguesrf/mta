//
//  Utils.m
//  MTA
//
//  Created by Renata Rodrigues on 8/1/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)trainToLineName:(NSString *)train
{
    NSString *lineName = @"";
    if ([train isEqualToString:@"1"] || [train isEqualToString:@"2"] || [train isEqualToString:@"3"]) {
        lineName = @"123";
    }
    else if ([train isEqualToString:@"4"] || [train isEqualToString:@"5"] || [train isEqualToString:@"6"]) {
        lineName = @"456";
    }
    else if ([train isEqualToString:@"7"]) {
        lineName = @"7";
    }
    else if ([train isEqualToString:@"A"] || [train isEqualToString:@"C"] || [train isEqualToString:@"E"]) {
        lineName = @"ACE";
    }
    else if ([train isEqualToString:@"B"] || [train isEqualToString:@"D"] || [train isEqualToString:@"F"]|| [train isEqualToString:@"M"]) {
        lineName = @"BDFM";
    }
    else if ([train isEqualToString:@"G"] ) {
        lineName = @"G";
    }
    else if ([train isEqualToString:@"J"] || [train isEqualToString:@"Z"]) {
        lineName = @"JZ";
    }
    else if ([train isEqualToString:@"L"] ) {
        lineName = @"L";
    }
    else if ([train isEqualToString:@"N"] || [train isEqualToString:@"Q"] || [train isEqualToString:@"R"]) {
        lineName = @"NQR";
    }
    else if ([train isEqualToString:@"S"] ) {
        lineName = @"S";
    }
    else if ([train isEqualToString:@"SIR"] ){
        lineName = @"SIR";
    }
    
    return lineName;
}

+ (int)findLineInArray:(NSArray *)lines forLineName:(NSString *)lineName
{
    int n = 0;
    // Finding in the array of lines, which Line has that name
    
    for (int t=0; t<lines.count; t++) {
        
        Line *thisLine = lines[t];
        
        if ([lineName isEqualToString:thisLine.name]) {
            n = t;
        }
    }
    return n;
}

+ (NSString *)statusNumberToSentence:(int)status {
    NSString *sentence = @"";
    if (status==0) {
        sentence = @"You are lucky today";
    } else if (status==1) {
        sentence = @"Expect some delay";
    } else if (status==2) {
        sentence = @"Planned work";
    }
    return sentence;
}


@end
