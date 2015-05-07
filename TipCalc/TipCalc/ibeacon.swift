//
//  ibeacon.swift
//  TipCalc
//
//  Created by sanu on 2/19/15.
//  Copyright (c) 2015 musadhikh. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

private var sharedInstanceClass = BeaconAnalysis(proximityUUID: "")

enum BeaconState: NSInteger {
    case kEnterRegion
    case kExitRegion
    case kDetermineRegion
    case kRegionFound
    case kInvalidRegion
    case kNoRegionFound
    case kLocationError
    case kMonitoringError
    case kRangingError
}



@objc protocol BeaconAnalisysDelegate : NSObjectProtocol {
    
    optional func beaconAnalysis(userInfo : NSDictionary)
}

class BeaconAnalysis : NSObject,CLLocationManagerDelegate  {
    
    var proximityUUID: NSUUID
    let majorValue: NSInteger!
    let minorValue: NSInteger!
    let beaconName: NSString!
    let fireInterval: NSTimeInterval!
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!
    var beaconState : BeaconState?
    var timer : NSTimer!
    var delegate : AnyObject?

    
    class var sharedInstance: BeaconAnalysis {
        return sharedInstanceClass
    }
    
    init(proximityUUID:NSString )
    {
        self.proximityUUID = NSUUID(UUIDString: proximityUUID)!;
        majorValue = -1
        minorValue = -1
        fireInterval=3.0
    }
    
    func startMonitoringBeacon() {
        setUPBeacon()
        searchForBeacon()
    }
    func setUPBeacon(){
        askForLocalNotificationPermission()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if majorValue > -1 {
            let major = CLBeaconMajorValue(majorValue)

            if minorValue > -1 {
                let minor = CLBeaconMinorValue(minorValue)

                beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: beaconName)
            }
            else{
                beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, identifier: beaconName)
            }
        }
        else{
            beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: beaconName)
        }
        
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true;
        beaconRegion.notifyOnExit = true;
        
        if locationManager.respondsToSelector("requestAlwaysAuthorization"){
            locationManager.requestAlwaysAuthorization()
        }
    }
    func searchForBeacon(){
        
        sharedInstanceClass = self;
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        
    }
    func askForLocalNotificationPermission(){
        
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings"){
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        }
        
    }
    
    func stopBeaconMonitoring(){
        locationManager.stopMonitoringForRegion(beaconRegion)
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    
    func notifyViewController(userInfo:NSDictionary){
        
        timer = NSTimer(timeInterval: fireInterval, target: self, selector: "notify", userInfo: userInfo, repeats: false)
    }
    
    func notify(timer:NSTimer){
        
        let userInfo: AnyObject? = timer.userInfo
        self.timer.invalidate()
        self.timer = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName("BeaconNotifier", object: userInfo)
    }
    
    func notifyUser(userInfo : NSDictionary){
        
        delegate?.beaconAnalysis!(userInfo)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        beaconState = .kEnterRegion
        
        notifyViewController([
            "Region":region,
            "LocationManager":manager
            ])
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        
        beaconState = .kExitRegion
        notifyViewController([
            "Region":region,
            "LocationManager":manager
            ])

        manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        
        beaconState = .kDetermineRegion
        
        notifyViewController([
            "Region":region,
            "LocationManager":manager
                                ])
        
        if state == CLRegionState.Inside{
            manager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        if beacons.count != 0 {
            
            if proximityUUID.isEqual(region.proximityUUID){
                beaconState = .kRegionFound
            }
            else{
                beaconState = .kInvalidRegion
            }
            
            if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
                
                notifyUser([
                    "Region":region,
                    "LocationManager":manager,
                    "Beacons" : beacons
                    ])
            }
            else{
                notifyViewController([
                    "Region":region,
                    "LocationManager":manager,
                    "Beacons" : beacons
                    ])
            }
            
        }
        else{
            beaconState = .kNoRegionFound
            if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
                
                notifyUser([
                    "Region":region,
                    "LocationManager":manager,
                    "Beacons" : beacons
                    ])

            }
            else{
                notifyViewController([
                    "Region":region,
                    "LocationManager":manager,
                    "Beacons" : beacons
                    ])

            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        beaconState = .kLocationError
        
        notifyViewController([
            "Error":error,
            "LocationManager":manager
            ])
    }
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        
        beaconState = .kMonitoringError
        notifyViewController([
            "Error":error,
            "LocationManager":manager,
            "Region":region
            ])
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        
        beaconState = .kRangingError
        notifyViewController([
            "Error":error,
            "LocationManager":manager,
            "Region":region
            ])
    }

    
    
 
   
}