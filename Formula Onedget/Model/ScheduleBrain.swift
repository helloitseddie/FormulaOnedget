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
        
        var appArray: [Data] = []
        let encoder = JSONEncoder()
        var fp1: Session
        var fp2: Session
        var fp3: Session?
        var quali: Session
        var sprint: Session?
        var raceTime: Session
        
        for race in apiData {
            fp1 = Session(date: race.FirstPractice.date, time: race.FirstPractice.time)
            fp2 = Session(date: race.SecondPractice.date, time: race.SecondPractice.time)
            quali = Session(date: race.Qualifying.date, time: race.Qualifying.time)
            
            if race.ThirdPractice != nil {
                fp3 = Session(date: race.ThirdPractice!.date, time: race.ThirdPractice!.time)
            } else if race.Sprint != nil {
                sprint = Session(date: race.Sprint!.date, time: race.Sprint!.time)
            }
            
            raceTime = Session(date: race.date, time: race.time)
            
            guard let encoded = try? encoder.encode(ScheduleInfo(roundRaw: race.round, raceName: race.raceName, circuitName: race.Circuit.circuitName, country: race.Circuit.Location.country, city: race.Circuit.Location.locality, fp1: fp1, fp2: fp2, fp3: fp3, sprint: sprint, quali: quali, race: raceTime)) else { return }
            
            appArray.append(encoded)
        }
        
        self.userDefaults?.setValue(appArray, forKey: "scheduleApp")
        WidgetCenter.shared.reloadAllTimelines()

    }
}
