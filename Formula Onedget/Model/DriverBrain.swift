//
//  DriverBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit

struct DriverBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getDrivers() {
        if let url = URL(string: "https://ergast.com/api/f1/current/driverStandings.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleDrivers(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
        
    func handleDrivers(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard let testData = data else { return }
        guard let formData = try? JSONDecoder().decode(DriverStandings.self, from: testData) else { return }
        let apiData = formData.MRData.StandingsTable.StandingsLists[0].DriverStandings
        
        var driverArray: [[String]] = []
        var driverInfo: [String] = []
        
        for driver in apiData {
            driverInfo.append(driver.position)
            driverInfo.append("\(driver.Driver.givenName) \(driver.Driver.familyName)")
            driverInfo.append(driver.Driver.familyName)
            driverInfo.append(driver.points)
            driverInfo.append(driver.Constructors[0].name)
            
            driverArray.append(driverInfo)
            
            driverInfo = []

        }
        
        self.userDefaults?.setValue(driverArray, forKey: "driverStandings")
        WidgetCenter.shared.reloadAllTimelines()

    }
}
