//
//  MainViewController.h
//  MTA
//
//  Created by Rafael Mumme on 7/29/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "FlipsideViewController.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Station.h"
#import "Line.h"
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, NSXMLParserDelegate, GMSMapViewDelegate>

- (IBAction)showInfo:(id)sender;

@end
