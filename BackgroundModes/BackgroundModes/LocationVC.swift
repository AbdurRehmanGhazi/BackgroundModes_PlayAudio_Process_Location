//
//  LocationVC.swift
//  BackgroundModes
//
//  Created by AbdurRehmanNineSol on 13/09/2022.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locations: [MKPointAnnotation] = []
        
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        //TODO: set desired accuracy to kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //TODO: request always authorization
        manager.requestAlwaysAuthorization()
        //TODO: setAllowsBackgroundUpdates
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func tapTrackingBtn(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Start Tracking" {
            sender.setTitle("Stop Tracking", for: .normal)
            locationManager.startUpdatingLocation()
        }
        else {
            sender.setTitle("Start Tracking", for: .normal)
            locationManager.stopUpdatingLocation()
        }
    }
}

extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let mostRecentLocation = locations.last else { return }
        
        // Add another location to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if array is too big
        while locations.count > 100 {
            let annoationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // also remove from the map
            mapView.removeAnnotation(annoationToRemove)
        }
        
        // TODO: Check application state
        
        if UIApplication.shared.applicationState == .active {
            self.mapView.showAnnotations(self.locations, animated: true)
        } else {
             print("App is in the background mode at location: \(mostRecentLocation)")
        }
    }
}
