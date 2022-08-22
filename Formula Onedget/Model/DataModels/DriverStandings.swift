//
//  DriverStandings.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import Foundation

struct DriverStandings: Codable {
    let MRData: MRData
}

struct MRData: Codable {
    let StandingsTable: StandingsTable
}

struct StandingsTable: Codable {
    let StandingsLists: [StandingsList]
}

struct StandingsList: Codable {
    let DriverStandings: [DriverStanding]
}

struct DriverStanding: Codable {
    let position: String
    let points: String
    let Driver: Driver
}

struct Driver: Codable {
    let givenName: String
    let familyName: String
}
