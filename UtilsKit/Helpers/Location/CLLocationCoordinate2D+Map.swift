//
//  CLLocationCoordinate2D+Map.swift
//  CoreDataUtilsKit
//
//  Created by David Douard on 08/02/2021.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {

/** Display an action sheet proposing to launch external Navigation application (Waze, Google Map, Map) and building itinary
     don't forget to add this autorization in the PLIST file of your project ;
     <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>googlechromes</string>
         <string>comgooglemaps</string>
         <string>waze</string>
     </array>
     */

    public func openIntMap() {
		let latitude: CLLocationDegrees = self.latitude
		let longitude: CLLocationDegrees = self.longitude
        
		let appleURL: String = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL: String = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL: String = "waze://?ll=\(latitude),\(longitude)&navigate=false"
		
		var actions: [AlertAction] = [
			("Maps", URL(string: appleURL)),
			("Google Map", URL(string: googleURL)),
			("Waze", URL(string: wazeURL))
		]
		.compactMap { name, url -> AlertAction? in
			guard let url = url, UIApplication.shared.canOpenURL(url) else { return nil }
			
			return AlertAction(title: name, style: .default) {
				url.open()
			}
		}

        let title = NSLocalizedString("TITLE_SELECT_NAVIGATION_APP", comment: "Selection")
        let message = NSLocalizedString("MESSAGE_SELECT_NAVIGATION_APP", comment: "Selectionner une application")
		let cancel = NSLocalizedString("CANCEL_NAVIGATION_APP", comment: "Fermer")
		
		actions.append(AlertAction(title: cancel, style: .cancel))
		
		AlertManager.shared.show(actions: actions, title: title, message: message, preferredStyle: .actionSheet)
    }
}
