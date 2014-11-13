//
//  LocateNewActivityViewController.h
//  LetsGo
//
//  Created by Nicholas on 14/11/12.
//
//

#ifndef LetsGo_LocateNewActivityViewController_h
#define LetsGo_LocateNewActivityViewController_h

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "CreateActivityScrollView.h"
#import "CreateActivityViewController.h"

@interface LocateNewActivityViewController : UIViewController

@property IBOutlet MKMapView *map;
@property IBOutlet UIImageView *centerIcon;
@property IBOutlet UISearchBar *searchBar;
@property CreateActivityViewController *createActView;

@end

@interface MapLocation : NSObject<MKAnnotation>

@property CLLocationCoordinate2D coordinate;
@property NSString *address;

@end

#endif
