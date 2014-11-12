//
//  LocateNewActivityViewController.m
//  LetsGo
//
//  Created by Nicholas on 14/11/12.
//
//

#import <Foundation/Foundation.h>
#import "LocateNewActivityViewController.h"

@interface LocateNewActivityViewController()<MKMapViewDelegate,UISearchBarDelegate>

@end

@implementation LocateNewActivityViewController

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
    self.map.delegate=self;
    self.searchBar.delegate=self;
    self.centerIcon.center=self.map.center;
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