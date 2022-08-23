//
//  ScheculeBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import UIKit
import WidgetKit

struct ScheduleBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getSchedule() {
        if let url = URL(string: "https://ergast.com/api/f1/current.json") {
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
        guard let formData = try? JSONDecoder().decode(Schedule.self, from: testData) else { return }
        let apiData = formData.MRData.RaceTable.Races
        
        
        var appArray: [[[String]]] = []
        var raceInfo: [[String]] = []
        
        for race in apiData {
            raceInfo.append([race.round])
            raceInfo.append([race.raceName])
            if race.ThirdPractice != nil {
                raceInfo.append(["FirstPractice", race.FirstPractice.date, race.FirstPractice.time])
                raceInfo.append(["SecondPractice", race.SecondPractice.date, race.SecondPractice.time])
                raceInfo.append(["ThirdPractice", race.ThirdPractice!.date, race.ThirdPractice!.time])
                raceInfo.append(["Qualifying", race.Qualifying.date, race.Qualifying.time])
            } else if race.Sprint != nil {
                raceInfo.append(["FirstPractice", race.FirstPractice.date, race.FirstPractice.time])
                raceInfo.append(["Qualifying", race.Qualifying.date, race.Qualifying.time])
                raceInfo.append(["SecondPractice", race.SecondPractice.date, race.SecondPractice.time])
                raceInfo.append(["Sprint", race.Sprint!.date, race.Sprint!.time])
            }
            raceInfo.append([race.date])
            raceInfo.append([race.time])
            appArray.append(raceInfo)

            raceInfo = []
        }
        
        self.userDefaults?.setValue(appArray, forKey: "scheduleApp")

    }
}
