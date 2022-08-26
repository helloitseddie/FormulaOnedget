//
//  ConstructorStandings.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import UIKit

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
    let nationality: String
}

struct ConstructorInfo {
    let data: [String]
    
    var position: String {
        return data[0]
    }
    
    var name: String {
        return data[1]
    }
    
    var points: String {
        return data[2]
    }
    
    var nationality: String {
        return data[3]
    }
    
    var drivers: [String] {
        var drivers: [String] = []
        for driver in data [4...] {
            drivers.append(driver)
        }
        return drivers
    }
    
    var constructorColor: UIColor {
        switch (name) {
        case "Red Bull":
            return UIColor(red: 30/255.0, green:
                            91/255.0, blue: 198/255.0, alpha: 1.0)
        case "Ferrari":
            return UIColor(red: 237/255.0, green:
                            28/255.0, blue: 36/255.0, alpha: 1.0)
        case "Mercedes":
            return UIColor(red: 108/255.0, green:
                            211/255.0, blue: 191/255.0, alpha: 1.0)
        case "McLaren":
            return UIColor(red: 245/255.0, green:
                            128/255.0, blue: 32/255.0, alpha: 1.0)
        case "Alpine F1 Team":
            return UIColor(red: 34/255.0, green:
                            147/255.0, blue: 209/255.0, alpha: 1.0)
        case "Alfa Romeo":
            return UIColor(red: 172/255.0, green:
                            32/255.0, blue: 57/255.0, alpha: 1.0)
        case "Haas F1 Team":
            return UIColor(red: 182/255.0, green:
                            186/255.0, blue: 189/255.0, alpha: 1.0)
        case "AlphaTauri":
            return UIColor(red: 78/255.0, green:
                            124/255.0, blue: 155/255.0, alpha: 1.0)
        case "Aston Martin":
            return UIColor(red: 45/255.0, green:
                            130/255.0, blue: 109/255.0, alpha: 1.0)
        case "Williams":
            return UIColor(red: 6/255.0, green:
                            97/255.0, blue: 249/255.0, alpha: 1.0)
        default:
            return UIColor(red: 0/255.0, green:
                            0/255.0, blue: 0/255.0, alpha: 1.0)
        }
    }
    
    var constructorFlag: String {
        switch (nationality) {
        case "Austrian":
            return "austria"
        case "Italian":
            return "italy"
        case "German":
            return "germany"
        case "French":
            return "france"
        case "British":
            return "britain"
        case "Swiss":
            return "switzerland"
        default:
            return "usa"
        }
    }
}
