//
//  Results.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 9/13/22.
//

import Foundation

struct Results: Codable {
    let MRData: ResMRData
}

struct ResMRData: Codable {
    let RaceTable: ResRaceTable
}

struct ResRaceTable: Codable {
    let Races: [ResRaces]
}

struct ResRaces: Codable {
    let round: String
    let Results: [Result]
}

struct Result: Codable {
    let position: String
    let positionText: String
    let points: String
    let Driver: Driver
}
