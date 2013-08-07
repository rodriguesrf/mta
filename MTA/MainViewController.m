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
#import "Station.h"
#import "Utils.h"
#import "SelectedLineViewController.h"

@interface MainViewController (){
    GMSMapView *mapView;
}

@property(nonatomic, weak) IBOutlet UIView *mapContainerView;
@property(nonatomic, strong) NSDate *timestamp;
@property(nonatomic, strong) NSMutableArray *stations;
@property(nonatomic, strong) NSMutableArray *lines;
@property(nonatomic, strong) Line *currentLine;
@property(nonatomic, strong) NSMutableString *currentElementValue;
@property(nonatomic, strong) NSMutableSet *selectedSetLines;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.selectedSetLines = [NSMutableSet setWithCapacity:0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7142
                                                            longitude:-74.0064
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:self.mapContainerView.frame camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    
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
    [self getServiceStatus];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mta.info/developers/data/nyct/subway/StationEntrances.csv"]];
    
    [AFCSVRequestOperation addAcceptableContentTypes:[NSSet setWithArray:@[ @"text/plain" ]]];
    
    AFCSVRequestOperation *operation = [AFCSVRequestOperation CSVRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id CSV) {
        
        __block GMSMutablePath *path = [GMSMutablePath path];
        
        [CSV enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if(idx > 0 && [obj count] > 3) {
                                
                GMSMarker *marker = [[GMSMarker alloc] init];
                
                float lat = [[obj objectAtIndex:3] floatValue];
                float lng = [[obj objectAtIndex:4] floatValue];
                
                [path addLatitude:lat longitude:lng];
                
                marker.position = CLLocationCoordinate2DMake(lat, lng);
                
                NSMutableString *trains = nil;
                NSString *lineName = nil;
                
                for (int n=5; n<16; n++) {
                    
                    NSString *train = [obj objectAtIndex:n];
                    
                    if([train length] > 0) {
                
                        lineName = [Utils trainToLineName:train];

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
              
              
                // finding the corresponding line object
              
                int lineIdx = [Utils findLineInArray:self.lines forLineName:lineName];

                Line *thisLine = self.lines[lineIdx];
                
                // check if the specific line is running OK
                
                if (thisLine.status == 0) {
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                }
                else if (thisLine.status == 1){
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                }
                else if (thisLine.status == 2){
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
                }
            
            }
            
        }];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV) {
        
        NSLog(@"Failure!");
        
    }];
    
    [operation start];

}

- (void)getServiceStatus
{
    
    self.lines = [NSMutableArray array];

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

- (void)callSelectedLineVC
{
   // new view controller of type SelectedLineViewController and setting it's selectedLine property to our nsset self.selectedSetLines
    SelectedLineViewController *controller = [[SelectedLineViewController alloc] initWithNibName:@"SelectedLineViewController" bundle:nil];

    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    controller.selectedLines = self.selectedSetLines;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
   // NSLog(@"%@", self.lines);
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
 
    if([elementName isEqualToString:@"line"]) {
        self.currentLine = [[Line alloc] init];
    }
 
    self.currentElementValue = nil; 
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"line"]) {
        [self.lines addObject:self.currentLine];
        self.currentLine = nil;
        
    } else {

        if([elementName isEqualToString:@"name"]) {
            self.currentLine.name = self.currentElementValue;
            // NSLog(@"self.currentLine.name: %@", self.currentLine.name);
        } else if([elementName isEqualToString:@"Date"]) {
            self.currentLine.date = self.currentElementValue;
        } else if([elementName isEqualToString:@"Time"]) {
            self.currentLine.time = self.currentElementValue;
        } else if([elementName isEqualToString:@"text"]) {
            self.currentLine.text = self.currentElementValue;
        } else if([elementName isEqualToString:@"status"]) {
            self.currentLine.status = [Line statusForString:self.currentElementValue];
        }
    }
    
    self.currentElementValue = nil;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentElementValue == nil) {
        NSMutableString *mutable = [NSMutableString stringWithString:string];
        self.currentElementValue = mutable;
    } else {
        [self.currentElementValue appendString:string];
    }
    
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    // When tapping the info window, we will write the selected station lines into the set selectedSetLines
    
    NSString *stationTrains = marker.snippet;
    
    // i+3 to account for space and "," between the train names
    for (NSUInteger i=0; i<[stationTrains length]; i=i+3) {

        unichar train = [stationTrains characterAtIndex:i];
        NSString *trainString = [NSString stringWithFormat:@"%c", train];        
        NSString *lineName = [Utils trainToLineName:trainString];
        
        Line *selectedLine = [[Line alloc] init];
        
        int i = [Utils findLineInArray:self.lines forLineName:lineName];
        
        selectedLine = self.lines[i];
        
        [self.selectedSetLines addObject:selectedLine];
            
    }
   
    [self callSelectedLineVC];
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
