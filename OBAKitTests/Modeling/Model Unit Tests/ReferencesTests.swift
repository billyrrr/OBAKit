//
//  ReferencesTests.swift
//  OBAKitTests
//
//  Copyright © Open Transit Software Foundation
//  This source code is licensed under the Apache 2.0 license found in the
//  LICENSE file in the root directory of this source tree.
//

import XCTest
import Nimble
import CoreLocation
@testable import OBAKit
@testable import OBAKitCore

// swiftlint:disable force_try

class ReferencesTests: OBATestCase {
    var references: References!

    override func setUp() {
        super.setUp()
        let data = Fixtures.loadData(file: "references.json")
        references = try! JSONDecoder.RESTDecoder.decode(References.self, from: data)
    }

    // MARK: - Agencies

    func test_agencies_success() {
        let agencies = references.agencies

        expect(agencies.count) == 1

        let agency = agencies.first!
        expect(agency.disclaimer).to(beNil())
        expect(agency.id) == "Hillsborough Area Regional Transit"
        expect(agency.language) == "en"
        expect(agency.name) == "Hillsborough Area Regional Transit"
        expect(agency.phone) == "813-254-4278"
        expect(agency.isPrivateService).to(beFalse())
        expect(agency.timeZone) == "America/New_York"
        expect(agency.agencyURL) == URL(string: "http://www.gohart.org")!
    }

    // MARK: - Routes

    func test_routes_success() {
        let routes = references.routes
        expect(routes.count) == 16

        let route = routes.first!
        expect(route.agencyID) == "Hillsborough Area Regional Transit"
        expect(route.agency.name) == "Hillsborough Area Regional Transit"
        expect(route.color).to(beCloseTo(UIColor(red: (9.0 / 255.0), green: (52.0 / 255.0), blue: (109.0 / 255.0), alpha: 1.0)))
        expect(route.routeDescription).to(beNil())
        expect(route.id) == "Hillsborough Area Regional Transit_1"
        expect(route.longName) == "Florida Avenue"
        expect(route.shortName) == "1"
        expect(route.textColor).to(beCloseTo(UIColor.white))
        expect(route.routeType) == .bus
        expect(route.routeURL) == URL(string: "http://www.gohart.org/routes/hart/01.html")!
    }

    // MARK: - Service Alerts

    func test_serviceAlerts_success() {
        let data = Fixtures.loadData(file: "arrival-and-departure-for-stop-MTS_11589.json")
        let response = try! JSONDecoder.RESTDecoder.decode(RESTAPIResponse<ArrivalDeparture>.self, from: data)
        let situations = response.references!.serviceAlerts

        expect(situations.count) == 1

        let situation = situations.first!

        let activeWindow = situation.activeWindows.first!
        expect(activeWindow.from) == Date(timeIntervalSinceReferenceDate: 1539781200)
        expect(activeWindow.to) == Date(timeIntervalSinceReferenceDate: 1539826200)

        let entity = situation.affectedEntities.first!
        expect(entity.routeID) == "MTS_10"

        let consequence = situation.consequences.first!
        expect(consequence.condition) == "detour"
        expect(consequence.conditionDetails!.diversionPath) == "ue}aHt~hiVYxHt@lIxAjD|`@pb@tDbHh@|EHvEU~l@fAfN`C~E|DvDbIvB|NdClMxCbEbA`CxDfB`FLrKsNl]gA{@gPGKjF"
        expect(consequence.conditionDetails?.stopIDs) == ["1_9972", "1_9974"]

        expect(situation.createdAt) == Date.fromComponents(year: 2018, month: 10, day: 13, hour: 02, minute: 26, second: 33)

        let desc = situation.situationDescription
        expect(desc?.lang) == "en"
        expect(desc?.value) == "Due to construction, the Washington St. off ramp from Pacific Highway will be closed Wednesday, October 17, from 6:30am - 6:30pm. Eastbound route 10 will detour, but will not miss any stops."

        expect(situation.id) == "MTS_RTA:11638227"
        expect(situation.publicationWindows) == []
        expect(situation.reason) == "CONSTRUCTION"
        expect(situation.severity) == ""
        expect(situation.summary.lang) == "en"
        expect(situation.summary.value) == "Washington St. ramp from Pac Hwy Closed"
        expect(situation.urlString).to(beNil())
    }

    // MARK: - Stops

    func test_stops_success() {
        let references = self.references!
        let stops = references.stops

        expect(stops.count) == 26

        let stop = stops.first!
        expect(stop.code) == "6497"
        expect(stop.direction) == .unknown
        expect(stop.id) == "Hillsborough Area Regional Transit_6497"
        expect(stop.location.coordinate.latitude).to(beCloseTo(28.066419, within: 0.01))
        expect(stop.location.coordinate.longitude).to(beCloseTo(-82.429872, within: 0.01))
        expect(stop.locationType) == .stop
        expect(stop.name) == "University Area Transit Center"
        expect(stop.routeIDs.count) == 10
        expect(stop.routeIDs.first!) == "Hillsborough Area Regional Transit_1"
        expect(stop.routes.first!.shortName) == "1"
        expect(stop.wheelchairBoarding) == .unknown
    }

    // MARK: - Trips

    func test_trips_success() {
        let trips = self.references!.trips

        expect(trips.count) == 30

        let trip = trips.first!

        expect(trip.blockID) == "Hillsborough Area Regional Transit_288317"
        expect(trip.direction).to(beNil())
        expect(trip.id) == "Hillsborough Area Regional Transit_99283"
        expect(trip.routeID) == "Hillsborough Area Regional Transit_9"
        expect(trip.route.shortName) == "9"
        expect(trip.routeShortName).to(beNil())
        expect(trip.shortName).to(beNil())
        expect(trip.serviceID) == "Hillsborough Area Regional Transit_We"
        expect(trip.timeZone).to(beNil())
        expect(trip.shapeID) == "Hillsborough Area Regional Transit_38042"
        expect(trip.headsign) == "Downtown to UATC via 15th St"
    }
}
