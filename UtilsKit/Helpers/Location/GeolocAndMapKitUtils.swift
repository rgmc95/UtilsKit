//
//  GeolocAndMapKitUtils.swift
//  CoreDataUtilsKit
//
//  Created by David Douard on 08/02/2021.
//

import Foundation
import MapKit

public protocol GeolocAndMapKitUtils {
    
}

extension UIViewController: GeolocAndMapKitUtils {

/** display an action sheet proposing to launch external Navigation application (Waze, Google Map, Plan) and building itinary with params : coordinates
     don't forget to add this autorization in the PLIST file of your project ;
     <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>googlechromes</string>
         <string>comgooglemaps</string>
         <string>waze</string>
     </array>

     - parameter coordinates: lat and lon to go to 
     */

    public func openMapButtonAction(coordinates: CLLocationCoordinate2D, fromVC: UIViewController) {
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }

        let title = NSLocalizedString("TITLE_SELECT_NAVIGATION_APP", comment: "Selection")
        let message = NSLocalizedString("MESSAGE_SELECT_NAVIGATION_APP", comment: "Selectionner une application")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        fromVC.present(alert, animated: true)
    }
}
