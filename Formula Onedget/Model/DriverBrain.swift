//
//  DriverBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit
import SwiftSoup

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
        
        var appArray: [[String]] = []
        var widgetArray: [[String]] = []
        var driverInfo: [String] = []
        var i = 0
        
        for driver in apiData {
            i += 1
            driverInfo.append(driver.position)
            driverInfo.append("\(driver.Driver.givenName) \(driver.Driver.familyName)")
            driverInfo.append(driver.points)
            appArray.append(driverInfo)
            
            if i < 6 {
                driverInfo[1] = driver.Driver.familyName
                widgetArray.append(driverInfo)
            }
            
            driverInfo = []
        }
        
        self.userDefaults?.setValue(widgetArray, forKey: "driverStandings")
        self.userDefaults?.setValue(appArray, forKey: "driverStandingsApp")

    }
}
