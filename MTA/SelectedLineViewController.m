//
//  SelectedLineViewController.m
//  MTA
//
//  Created by Renata Rodrigues on 8/3/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "SelectedLineViewController.h"
#import "Utils.h"

@interface SelectedLineViewController ()

@end

@implementation SelectedLineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    // converting the NSSet self.selectedLines to an array
    NSMutableArray *linesArray = [NSMutableArray arrayWithArray:[self.selectedLines allObjects]];
    
    for (int i=0; i<linesArray.count; i++) {
        Line *line = linesArray[i];
        NSLog(@"line: %@",line);
        
        // just an example
        if (i==0) {
            self.statusLabel.text = [Utils statusNumberToSentence:line.status];
            self.lineLabel.text = line.name;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
