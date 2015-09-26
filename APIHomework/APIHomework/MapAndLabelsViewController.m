//
//  MapAndLabelsViewController.m
//  APIHomework
//
//  Created by Varindra Hart on 9/25/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//
#pragma mark INFO
//  MAIN DETAIL VIEW CONTROLLER

#import "MapAndLabelsViewController.h"
#import "DetailViewController.h"
#import "WebViewController.h"
@import GoogleMaps;

@interface MapAndLabelsViewController ()<UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIView *viewForMap;
@property (nonatomic) GMSPlacePicker *placePicker;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *address2;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation MapAndLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self embedMap];
    [self setUpLabels];
    
    //[self googlePlacesData];
    // Do any additional setup after loading the view.
}

- (void)setUpLabels{
    
    self.name.text = self.entry.name;
    
    if ([self.entry.formattedAddress count]>0) {
        self.address.text = self.entry.formattedAddress[0];
    }
    else{
        self.address.text = @"No Registered Location";
    }
    if (self.entry.formattedAddress.count >1){
        self.address2.text = self.entry.formattedAddress[1];
    }
    else{
        self.address2.text = @"";
    }
    
    if (self.entry.url!=nil) {
        [self.urlButton setTitle:self.entry.url forState:UIControlStateNormal];
    }
    else{
        [self.urlButton setTitle:@"" forState:UIControlStateNormal];
        self.urlButton.hidden = YES;
    }
    
}

- (void)launchWebView{
    
    [self.activityIndicator startAnimating];
    
    if ([self hasUrl]) {
        
    NSString *encodeString = [self.entry.menuUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodeString]];
    
    self.webView.delegate = self;
    
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             [self.webView loadRequest:request];
             
         }
         else if (error != nil){
             NSLog(@"Error: %@", error);
             
         }
         
     }];

    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh!" message:@"It seems they don't have a mobile menu!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)embedMap{
    
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.entry = self.entry;
    
    detailVC.view.frame = self.viewForMap.bounds;
    [self.viewForMap addSubview:detailVC.view];
    [detailVC willMoveToParentViewController:self];
    
}
- (IBAction)rightBarButtonTapped:(UIBarButtonItem *)sender {
    
    if (self.infoView.hidden==NO) {
        [self launchWebView];
        self.infoView.hidden = YES;
        [self.rightBarButton setTitle:@"Info"];
    }
    
    else{
        self.infoView.hidden = NO;
        [self.rightBarButton setTitle:@"Menu"];
        self.activityIndicator.hidden = NO;
        if([self.activityIndicator isAnimating]){
        [self.activityIndicator stopAnimating];
        }
    }
    
}

- (BOOL)hasUrl{
    
    if ([self.entry.menuUrl isEqualToString:@""] || self.entry.menuUrl == nil) {
        return NO;
    }
    
    return YES;
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [self rightBarButtonTapped:self.rightBarButton];
    
}


#pragma mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

#pragma mark PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        WebViewController *webVC = segue.destinationViewController;
        webVC.url = self.entry.url;
    }
    
}

//- (void)googlePlacesData{
//
//    CLLocationCoordinate2D VIEWPORT_LATLNG = CLLocationCoordinate2DMake([self.entry.lat doubleValue],[self.entry.lng doubleValue]);
//    float VIEWPORT_DELTA = 0.001;
//
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(VIEWPORT_LATLNG.latitude + VIEWPORT_DELTA,
//                                                                  VIEWPORT_LATLNG.longitude + VIEWPORT_DELTA);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(VIEWPORT_LATLNG.latitude - VIEWPORT_DELTA,
//                                                                  VIEWPORT_LATLNG.longitude - VIEWPORT_DELTA);
//    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
//                                                                         coordinate:southWest];
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
//    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
//
//    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
//
//        NSLog(@"%@",place);
////        self.nameLabel.text = @"";
////        self.attributionTextView.text = @"";
////
////        if (error != nil) {
////            self.nameLabel.text = [error localizedDescription];
////            return;
////        }
////
////        if (place != nil) {
////            self.nameLabel.text = place.name;
////            self.attributionTextView.attributedText = place.attributions;
////        } else {
////            self.nameLabel.text = @"No place selected";
////        }
//    }];
//}



@end
