//
//  Schedule.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import Foundation

import Foundation

struct Schedule: Codable {
    let MRData: SchMRData
}

struct SchMRData: Codable {
    let RaceTable: RaceTable
}

struct RaceTable: Codable {
    let Races: [Races]
}

struct Races: Codable {
    let round: String
    let raceName: String
    let FirstPractice: Session
    let SecondPractice: Session
    let ThirdPractice: Session?
    let Qualifying: Session
    let Sprint: Session?
    let date: String
    let time: String
}

struct Session: Codable {
    let date: String
    let time: String
}
