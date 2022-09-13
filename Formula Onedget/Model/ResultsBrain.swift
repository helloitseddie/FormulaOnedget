//
//  ResultsBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 9/12/22.
//

import UIKit

struct ResultsBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getResults(round: Int) {
        if let url = URL(string: "https://ergast.com/api/f1/2022/\(round)/results.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleSchedule(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
        
    func handleSchedule(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard let testData = data else { return }
        guard let formData = try? JSONDecoder().decode(Results.self, from: testData) else { return }
        let apiData = formData.MRData.RaceTable.Races
        
        guard let resArray = self.userDefaults?.value(forKey: "raceResults") as? [ResRaces?] else { return }
        var newResArray: [ResRaces?] = resArray
        var appArray: [Data?] = []
        let encoder = JSONEncoder()
        
        if apiData.count > 0 {
            newResArray.append(apiData[0])
        } else {
            newResArray.append(nil)
        }
        
        for result in newResArray {
            var appData: Data?
            
            if result != nil {
                guard let test = try? encoder.encode(result) else { return }
                appData = test
            } else {
                appData = nil
            }
            appArray.append(appData)
        }
        
        self.userDefaults?.setValue(appArray, forKey: "raceResults")

    }
}
