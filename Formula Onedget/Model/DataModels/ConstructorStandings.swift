//
//  ConstructorStandings.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import Foundation

struct ConstructorStandings: Codable {
    let MRData: ConstMRData
}

struct ConstMRData: Codable {
    let StandingsTable: ConstStandingsTable
}

struct ConstStandingsTable: Codable {
    let StandingsLists: [ConstStandingsList]
}

struct ConstStandingsList: Codable {
    let ConstructorStandings: [ConstructorStanding]
}

struct ConstructorStanding: Codable {
    let position: String
    let points: String
    let Constructor: Constructor
}

struct Constructor: Codable {
    let name: String
}
