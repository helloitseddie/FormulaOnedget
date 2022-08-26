//
//  ConstructorBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit

struct ConstructorBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getConstructors() {
        if let url = URL(string: "https://ergast.com/api/f1/current/constructorStandings.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleConstructors(data:response:error:))
            task.resume()
            task.suspend()
        }
        
        if let url = URL(string: "https://ergast.com/api/f1/current/driverStandings.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleDrivers(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
    
    func handleConstructors(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard let testData = data else { return }
        guard let formData = try? JSONDecoder().decode(ConstructorStandings.self, from: testData) else { return }
        let apiData = formData.MRData.StandingsTable.StandingsLists[0].ConstructorStandings
        
        var constArray: [[String]] = []
        var constInfo: [String] = []
        
        for const in apiData {
            constInfo.append(const.position)
            constInfo.append("\(const.Constructor.name)")
            constInfo.append(const.points)
            constInfo.append("\(const.Constructor.nationality)")
            constArray.append(constInfo)
            
            constInfo = []
        }
        
        self.userDefaults?.setValue(constArray, forKey: "constructorStandings")
    }
    
    func handleDrivers(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard let testData = data else { return }
        guard let formData = try? JSONDecoder().decode(DriverStandings.self, from: testData) else { return }
        let apiData = formData.MRData.StandingsTable.StandingsLists[0].DriverStandings
        
        guard let constArray = self.userDefaults?.value(forKey: "constructorStandings") as? [[String]] else { return }
        
        var newConstArray: [[String]] = []
        var temp: [String] = []
        for constructorRaw in constArray {
            let constructor = ConstructorInfo(data: constructorRaw)
            
            temp = constructorRaw
            
            for driver in apiData {
                if driver.Constructors[0].name == constructor.name {
                    temp.append(driver.Driver.familyName)
                }
            }
            
            newConstArray.append(temp)
            temp = []
        }
        
        self.userDefaults?.setValue(newConstArray, forKey: "constructorStandingsWithDrivers")

    }
}
