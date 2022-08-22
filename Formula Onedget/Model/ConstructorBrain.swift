//
//  ConstructorBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit
import SwiftSoup

struct ConstructorBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getConstructors() {
        if let url = URL(string: "https://ergast.com/api/f1/current/constructorStandings.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleConstructors(data:response:error:))
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
        
        var appArray: [[String]] = []
        var widgetArray: [[String]] = []
        var constInfo: [String] = []
        var i = 0
        
        for const in apiData {
            i += 1
            constInfo.append(const.position)
            constInfo.append("\(const.Constructor.name)")
            constInfo.append(const.points)
            appArray.append(constInfo)
            
            if i < 6 {
                widgetArray.append(constInfo)
            }
            
            constInfo = []
        }
        
        self.userDefaults?.setValue(widgetArray, forKey: "constructorStandings")
        self.userDefaults?.setValue(appArray, forKey: "constructorStandingsApp")
    }
}
