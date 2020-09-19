//
//  RadarTracking.swift
//  covidTracing
//
//  Created by Siddharth on 9/19/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import Foundation
import RadarSDK

class RadarTracking {
    
    /*
     
     Insert a summary here later of what this is for.
     
     */
    
    public func tracking() {
        
        // Creating a variable to input into Radar's startTracking function and all of the options
        var trackOptions: RadarTrackingOptions = RadarTrackingOptions()
        // Counting how many seconds someone has been stationary
        trackOptions.desiredStoppedUpdateInterval = 0 //This will start at zero seconds
        // Counting how many seconds someone is moving for
        trackOptions.desiredMovingUpdateInterval = 30 // Updates movement every 30 seconds
        // This is for location accuracy
        trackOptions.desiredAccuracy = .high // This will make sure that accuracy is highest
        // Distance after which we start tracking movement
        trackOptions.stopDistance = 5 // This will start tracking after person has moved 5 meters
        // Time interval for someone to be still for app to stop location tracking
        trackOptions.stopDuration = 300  // After a person is still for 5 minutes, we will mark them as stopped
        // Creates a geofence around user after person has stopped
        trackOptions.useStoppedGeofence = true
        // Create radius of geofence around user after stopping
        trackOptions.stoppedGeofenceRadius = 20 // Will create a radius of 20 meters around the user after stopping for 5 mins
        //
        
        Radar.startTracking(trackingOptions: trackOptions)
    }
    
    
    
}
