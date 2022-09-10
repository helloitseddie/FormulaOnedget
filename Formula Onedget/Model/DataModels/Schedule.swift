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
    let Circuit: Circuit
    let FirstPractice: Session
    let SecondPractice: Session
    let ThirdPractice: Session?
    let Qualifying: Session
    let Sprint: Session?
    let date: String
    let time: String
}

struct Circuit: Codable {
    let circuitName: String
    let Location: Location
}

struct Location: Codable {
    let locality: String
    let country: String
}

struct Session: Codable {
    let date: String
    let time: String
}

struct ScheduleInfo: Codable {
    let roundRaw: String
    
    var round: Int {
        return Int(roundRaw)!
    }
    
    let raceName: String
    let circuitName: String
    let country: String
    let city: String
    
    let fp1: Session
    let fp2: Session
    let fp3: Session?
    let sprint: Session?
    let quali: Session
    let race: Session
    
    
}
