//
//  ViewController.m
//  APIHomework
//
//  Created by Varindra Hart on 9/24/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"
#import "APImanager.h"
#import "FourSquareEntry.h"
#import "MapAndLabelsViewController.h"

NSString * const foursquareURL = @"https://api.foursquare.com/v2/venues/search?client_id=WKKKR2YZPIZCDILZ4GN5NBAY0YYN4DF3P2S4PQY5SSC2K5VN&client_secret=PYK0IPHF5KS1ALSD4TSOQWDKWIGAINV3II2T3E2IF5WPGZR1&v=20130815&ll=40.7,-74&radius=10000&query=sushi";

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic) NSMutableArray *foursquareData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSString * currentSearch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.searchField.delegate = self;
    
    self.currentSearch = @"pizza";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self setUpLocationManager];
    [self fetchData];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    
    [self.tableView reloadData];
    [self fetchData];
    [refreshControl endRefreshing];
}

- (void)setUpLocationManager{
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [self.locationManager requestAlwaysAuthorization];
        }
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.foursquareData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    FourSquareEntry *newEntry = [self.foursquareData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = newEntry.name;
    
    return cell;
}

#pragma mark Fetching Methods
- (void)fetchData{
    NSString *foursquareURLmod = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=WKKKR2YZPIZCDILZ4GN5NBAY0YYN4DF3P2S4PQY5SSC2K5VN&client_secret=PYK0IPHF5KS1ALSD4TSOQWDKWIGAINV3II2T3E2IF5WPGZR1&v=20130815&ll=%f,%f&radius=1000&query=%@",self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude,self.currentSearch];
    NSString *encodeString = [foursquareURLmod stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [APImanager GETRequestWithUrl:[NSURL URLWithString:encodeString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data!=nil){
           
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",json);
            
            self.foursquareData = [NSMutableArray new];
            
            NSArray *venues = [[json objectForKey:@"response"] objectForKey:@"venues"];
            
            for (NSDictionary *entry in venues) {
                FourSquareEntry *newEntry = [FourSquareEntry new];
                newEntry.name = [entry objectForKey:@"name"];
                newEntry.lat = [[entry objectForKey:@"location"]objectForKey:@"lat"];
                newEntry.lng = [[entry objectForKey:@"location"]objectForKey:@"lng"];
                newEntry.formattedAddress = [[entry objectForKey:@"location"] objectForKey:@"formattedAddress"];
                newEntry.phoneNumber = entry[@"contact"][@"formattedPhone"];
                newEntry.url = entry[@"url"];
                
                newEntry.menuUrl = entry[@"menu"][@"mobileUrl"];
                
                [self.foursquareData addObject:newEntry];
                
            }
            
        }
        [self.tableView reloadData];
    }];
}

#pragma mark Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    FourSquareEntry *entry = self.foursquareData[indexPath.row];
    
    MapAndLabelsViewController *detailVC = segue.destinationViewController;
    
    detailVC.entry = entry;
    
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    NSString *checkString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![checkString isEqualToString:@""]) {
        self.currentSearch = textField.text;
        [self fetchData];
    }
    
    return YES;
}

@end
