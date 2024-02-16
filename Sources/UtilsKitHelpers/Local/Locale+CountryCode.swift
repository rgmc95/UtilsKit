//
//  Locale+CountryCode.swift
//
//
//  Created by Michael Coqueret on 16/02/2024.
//

import Foundation

public extension Locale {
	
	/**
	 Retrieves the ISO country code for a given country name.
	 - Parameter countryName: The name of the country for which the ISO code is sought.
	 - Returns: The ISO country code corresponding to the provided country name, or the original name if no match is found.
	 - Note: If the input `countryName` has a length of 2, it is assumed to already be in ISO code format and is returned as is.
	 **/
	func isoCode(for countryName: String) -> String {
		if countryName.count == 2 { return countryName }
		return Locale.isoRegionCodes.first { code -> Bool in
			localizedString(forRegionCode: code)?
				.compare(countryName,
						 options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
		} ?? countryName
	}
}
