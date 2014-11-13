//
//  LocateNewActivityViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/12.
//
//

#import <Foundation/Foundation.h>
#import "LocateNewActivityViewController.h"

@interface LocateNewActivityViewController()<MKMapViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate>

@end

@implementation LocateNewActivityViewController


-(void)initLoc{
    self.locMgr = [[CLLocationManager alloc]init];
    self.locMgr.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locMgr requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]){
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locMgr startUpdatingLocation];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启定位后可自动选择您所在的学校" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc = [locations lastObject];
    MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(loc.coordinate, 10000, 10000);
    [self.map setRegion:viewRegion animated:YES];
    [self.locMgr stopUpdatingLocation];
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"location paused");
}


-(IBAction)setLocate:(id)sender{
    NSArray *views=self.navigationController.viewControllers;
    self.createActView=views[views.count-2];
    self.createActView.lat=[[NSNumber alloc]initWithFloat:self.map.centerCoordinate.latitude];
    self.createActView.lon=[[NSNumber alloc]initWithFloat:self.map.centerCoordinate.longitude];
    self.createActView.txtActPlace.text=self.searchBar.text;
    [self.navigationController popToViewController:views[views.count-2] animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CLLocationCoordinate2D center=self.map.centerCoordinate;
    CLLocation *loc=[[CLLocation alloc]initWithCoordinate:center altitude:CLLocationDistanceMax horizontalAccuracy:kCLLocationAccuracyBest verticalAccuracy:kCLLocationAccuracyBest timestamp:[[NSDate alloc]initWithTimeIntervalSinceNow:0]];
    CLGeocoder *gcoder=[[CLGeocoder alloc]init];
    [gcoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count>0) {
            CLPlacemark *place=placemarks[0];
            NSDictionary *addressDic=place.addressDictionary;
            self.searchBar.text=[addressDic objectForKey:@"Street"];
        }
    }];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    
    CLGeocoder *gcoder=[[CLGeocoder alloc]init];
    [gcoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count>0) {
            [self.map removeAnnotations:self.map.annotations];
        }
        for (int i=0; i<placemarks.count; i++) {
            CLPlacemark *placemark=placemarks[i];
            MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
            [self.map setRegion:viewRegion animated:YES];
            MapLocation *anno=[[MapLocation alloc]init];
            anno.address=placemark.thoroughfare;
            anno.coordinate=placemark.location.coordinate;
            [self.map addAnnotation:anno];
        }
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

-(void)viewDidLoad{
    [self initLoc];
    self.map.delegate=self;
    self.searchBar.delegate=self;
    UIImageView *center=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker-48"]];
    CGRect viewFrame=self.view.frame;
    center.center=CGPointMake(viewFrame.size.width/2, self.map.center.y-25);
    [self.view addSubview:center];
}

@end

@implementation MapLocation

-(NSString *)title{
    return @"您的位置";
}

-(NSString *)subtitle{
    return self.address;
}

@end