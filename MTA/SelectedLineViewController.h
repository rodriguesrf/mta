//
//  SelectedLineViewController.h
//  MTA
//
//  Created by Renata Rodrigues on 8/3/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"

@interface SelectedLineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSMutableSet *selectedLines;
@end
