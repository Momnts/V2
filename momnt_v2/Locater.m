//
//  Locater.m
//  PetDiscount
//
//  Created by Naren Sathiya on 10/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "Locater.h"


@implementation Locater

    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    static Locater *sharedLocater = nil;
    ServerCalls *client;
    NSString *currentUser;


+ (Locater*) sharedLocater
{
    if(sharedLocater == nil)
        sharedLocater = [[super alloc] init];
    
    return sharedLocater;
}

- (void) initLocater:(NSString *) userId
{
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    client = [[ServerCalls alloc] init];
    currentUser = userId;
   
   
}

- (void) startUpdating
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 5;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    
    client.delegate = self;
    
    //NSLog(@"About to start updating location");
    
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void) stopUpdating
{
    [locationManager stopUpdatingLocation];
}

- (NSMutableDictionary *) returnLatAndLong
{
    //NSLog(@"returning lat and long");
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    [location setObject:_currentLatitude forKey:@"lat"];
    [location setObject:_currentLongitude forKey:@"lng"];
    
    return location;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        _currentLatitude =  [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _currentLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
         //NSLog(@"current Longitude: %@", _currentLongitude);
         //NSLog(@"current Latitude: %@", _currentLatitude);
        
        //[client updateLocation:currentUser withLat:_currentLatitude withLng:_currentLongitude];
    }
    /*
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _curentAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
     */
}



-(void) client:(ServerCalls *) serverCalls sendUpdateLocationSuccess:(NSDictionary *)responseObject
{
    
    int success = [[responseObject objectForKey:@"success"] intValue];
    if(success==1)
    {
        NSLog(@"success");
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Sign-up unsuccessful. Please check fields"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/*
- (void)updatedisplay:(CCViewController *)vc
{
    
    NSLog(@"about to update display");
    vc.latitudeLabel.text = _currentLatitude;
    vc.LongitudeLabel.text = _currentLongitude;
    vc.addressLabel.text = _curentAddress;
    
    
    //[locationManager stopUpdatingLocation];
}

*/

@end
