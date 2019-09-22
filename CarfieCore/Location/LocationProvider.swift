//
//  LocationProvider.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/18/19.
//  Copyright © 2019 espy. All rights reserved.
//

import CoreLocation
import Foundation

public protocol LocationProvider {
    func requestLocationPermissions()
    func startUpdatingLocation()

    func registerForLocationUpdates(_ observer: AnyObject, locationUpdated: @escaping (CLLocation) -> Void)
    func unregisterForLocationUpdates(_ observer: AnyObject)
}

public final class DefaultLocationProvider: NSObject, LocationProvider {

    public static let shared = DefaultLocationProvider()

    let locationManager = CLLocationManager()

    private let multicastDelegate: MulticastNotifier<CLLocation>

    private override init() {
        multicastDelegate = MulticastNotifier()
        super.init()
        locationManager.delegate = self
    }

    public func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func startUpdatingLocation() {
        startLocationUpdates(for: CLLocationManager.authorizationStatus())
    }

    public func registerForLocationUpdates(_ observer: AnyObject, locationUpdated: @escaping (CLLocation) -> Void) {
        multicastDelegate.subscribe(observer, withBlock: locationUpdated)
    }

    public func unregisterForLocationUpdates(_ observer: AnyObject) {
        multicastDelegate.remove(observer)
    }

    private func startLocationUpdates(for authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            requestLocationPermissions()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationManager.stopUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DefaultLocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startLocationUpdates(for: status)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        multicastDelegate.notify(withResult: location)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
