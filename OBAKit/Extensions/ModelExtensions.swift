//
//  ModelExtensions.swift
//  OBAKit
//
//  Copyright © Open Transit Software Foundation
//  This source code is licensed under the Apache 2.0 license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import MapKit
import OBAKitCore

// MARK: - Region/MKAnnotation

extension Region: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        centerCoordinate
    }

    public var title: String? {
        name
    }
}

// MARK: - Stop/MKAnnotation

/// Adds conformance to `MKAnnotation` to `Stop`.
/// Includes additional methods for rendering extra data directly onto the map.
///
/// - Note: See `StopAnnotationView`for more details.
extension Stop: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }

    public var title: String? {
        Formatters.formattedTitle(stop: self)
    }

    public var subtitle: String? {
        Formatters.formattedRoutes(routes)
    }

    public var mapTitle: String? {
        routes.map { $0.shortName }.prefix(3).joined(separator: ", ")
    }

    public var mapSubtitle: String? {
        Formatters.adjectiveFormOfCardinalDirection(direction)
    }
}

// MARK: - TripStatus/MKAnnotation

/// Adds conformance to `MKAnnotation` to `TripStatus`.
extension TripStatus: MKAnnotation {

    public var coordinate: CLLocationCoordinate2D {
        lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    public var title: String? {
        activeTrip.routeShortName
    }
}

// MARK: - TripStopTime/MKAnnotation

/// Adds conformance to `MKAnnotation` to `TripStopTime`.
///
/// - Note: See `MinimalStopAnnotationView`for more details.
extension TripStopTime: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        stop.location.coordinate
    }

    public var title: String? {
        Formatters.formattedTitle(stop: stop)
    }

    public var subtitle: String? {
        nil
    }
}
