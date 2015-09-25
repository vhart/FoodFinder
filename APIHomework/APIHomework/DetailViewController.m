//
//  DetailViewController.m
//  APIHomework
//
//  Created by Varindra Hart on 9/24/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//
@import GoogleMaps;
#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic) GMSMapView *mapView_;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMaps];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpMaps{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.entry.lat floatValue]
                                                            longitude:[self.entry.lng floatValue]
                                                                 zoom:15];
    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;
    //self.viewForMap = self.mapView_;
    self.view = self.mapView_;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.entry.lat floatValue], [self.entry.lng floatValue]);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
    marker.map = self.mapView_;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
