//
//  MainViewController.m
//  MTA
//
//  Created by Rafael Mumme on 7/29/13.
//  Copyright (c) 2013 Renata Rodrigues. All rights reserved.
//

#import "MainViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import <AFCSVRequestOperation/AFCSVRequestOperation.h>
#import <AFXMLRequestOperation.h>

#import "Line.h"

@interface MainViewController (){
    GMSMapView *mapView;
}

@property(nonatomic, weak) IBOutlet UIView *mapContainerView;
@property(nonatomic, strong) NSDate *timestamp;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, strong) Line *currentLine;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7142
                                                            longitude:-74.0064
                                                                 zoom:14];
    mapView = [GMSMapView mapWithFrame:self.mapContainerView.frame camera:camera];
    mapView.myLocationEnabled = YES;
    
    [self.mapContainerView addSubview:mapView];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    mapView.frame = self.view.bounds;
    
    [self getSubwayStations];
    
}

- (void)getSubwayStations
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mta.info/developers/data/nyct/subway/StationEntrances.csv"]];
    
    [AFCSVRequestOperation addAcceptableContentTypes:[NSSet setWithArray:@[ @"text/plain" ]]];
    
    AFCSVRequestOperation *operation = [AFCSVRequestOperation CSVRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id CSV) {
        
        [CSV enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if(idx > 0 && [obj count] > 3) {
                GMSMarker *marker = [[GMSMarker alloc] init];
                
                float lat = [[obj objectAtIndex:3] floatValue];
                float lng = [[obj objectAtIndex:4] floatValue];
                
                marker.position = CLLocationCoordinate2DMake(lat, lng);
                
                NSMutableString *trains = nil;
                for (int n=5; n<16; n++) {
                    
                    NSString *train = [obj objectAtIndex:n];
                    if([train length] > 0) {
                        
                        if(trains == nil) {
                            trains = [NSMutableString stringWithFormat:@"%@", train];
                        } else {
                            [trains appendFormat:@", %@", train];
                        }
                        
                    }

                }
                
                NSString *stationName = [obj objectAtIndex:2];
                marker.title = stationName;
                marker.snippet = trains;
                marker.map = mapView;
            }
            
        }];
        
        [self getServiceStatus];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV) {
        
        NSLog(@"Failure!");
        
    }];
    
    [operation start];

}

- (void)getServiceStatus
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.mta.info/status/serviceStatus.txt"]];
    
    [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithArray:@[ @"text/plain" ]]];

    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        
        NSLog(@"Failure!");

    }];
    [operation start];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {

    if([elementName isEqualToString:@"line"]) {
        self.currentLine = [[Line alloc] init];
    }
    if([elementName isEqualToString:@"name"]) {
    }
    
    NSLog(@"%@", elementName);
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%@", string);
}  

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
