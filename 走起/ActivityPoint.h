//
//  ActivityPoint.h
//  LetsGo
//
//  Created by 周瑞琦 on 11/7/14.
//
//

#import <Foundation/Foundation.h>
#import<MapKit/MapKit.h>
@interface ActivityPoint : NSObject<MKAnnotation>

@property (nonatomic,readwrite) CLLocationCoordinate2D coordinate;


@end
