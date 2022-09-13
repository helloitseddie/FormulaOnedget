//
//  ScheduleViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import UIKit

class ScheduleViewController: UIViewController {

    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var driverButt: UIButton!
    @IBOutlet weak var constButt: UIButton!
    @IBOutlet weak var scheduleButt: UIButton!
    @IBOutlet weak var plsButt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    let weekImage = UIImageView()
    let dayImage = UIImageView()
    let hourImage = UIImageView()
    let minImage = UIImageView()
    let secImage = UIImageView()
    
    let weekTimer = UILabel()
    let dayTimer = UILabel()
    let hourTimer = UILabel()
    let minTimer = UILabel()
    let secTimer = UILabel()
    
    var countdown: Timer?
    var individualRace: IndividualRace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverButt.imageView?.alpha = 0.5
        constButt.imageView?.alpha = 0.5
        scheduleButt.imageView?.alpha = 1
        plsButt.imageView?.alpha = 0.5
        
        let scheduleBrain = ScheduleBrain()
        scheduleBrain.getSchedule()
        
        setSchedule()
    }
    
    fileprivate func setSchedule() {
        guard let schedule = self.userDefaults?.value(forKey: "scheduleApp") as? [Data] else { return }
        
        let containerHeight: Float = (100.0 * Float(schedule.count)) + 100 + (5.0 * Float(schedule.count - 1))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.isUserInteractionEnabled = true
        labelView.isUserInteractionEnabled = true
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        var labelContainer: UIView
        var labelBG: UIImageView
        
        var raceName: UILabel
        
        var isNextRace = true
        var offset: Float = 0
        
        var raceButt: UIButton
        var timerView: UIView
        
        for raceRaw in schedule {
            guard let race = try? JSONDecoder().decode(ScheduleInfo.self, from: raceRaw) else { return }
            labelContainer = UIView()
            labelContainer.isUserInteractionEnabled = true
            labelContainer.translatesAutoresizingMaskIntoConstraints = false
            
            labelBG = UIImageView()
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            
            timerView = UIView()
            
            raceButt = UIButton()
            raceButt.backgroundColor = .clear
            raceButt.tag = race.round - 1
            raceButt.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
            
            raceName = UILabel()
                                 
            if checkDate("\(race.race.date)T\(race.race.time)") && isNextRace {
                raceName.textColor = #colorLiteral(red: 0.7961815596, green: 0.3117287159, blue: 0.08521645516, alpha: 1)
                offset = (Float(scrollView.contentSize.height) / Float(schedule.count) * Float(race.round))
                offset -= (Float(scrollView.frame.height / 2) + 50)
                self.userDefaults?.setValue(formatRace(race), forKey: "schedule")
                
                labelContainer.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(200))
                labelContainer.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
                
                labelBG.frame.size = CGSize(width: scrollView.contentSize.width - 20, height: CGFloat(200))
                labelBG.layer.borderColor = #colorLiteral(red: 0.7945286036, green: 0.3097311854, blue: 0.08659250289, alpha: 1)
                labelBG.layer.borderWidth = 4
                
                setTimer(papaView: timerView, background: labelBG, race: race)
                timerView.center.x = labelContainer.center.x
                timerView.center.y = labelBG.center.y + 50
                
                raceButt.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(200))
                raceButt.center = labelContainer.center
                
                isNextRace = false
            } else {
                raceName.textColor = .black
                labelContainer.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
                labelContainer.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
                labelBG.frame.size = CGSize(width: scrollView.contentSize.width - 20, height: CGFloat(100))
                
                raceButt.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
                raceButt.center = labelContainer.center
            }
            
            labelContainer.addSubview(labelBG)
            
            // Left
            let round = UILabel()
            round.frame.size = CGSize(width: labelBG.frame.width * 0.2, height: 50)
            round.text = "\nRound\n\(race.round)\n"
            round.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            round.textColor = .black
            round.numberOfLines = 0
            round.textAlignment = .center
            round.layer.borderColor = #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1)
            round.layer.borderWidth = 2
            round.layer.cornerRadius = 8
            labelBG.addSubview(round)
            round.translatesAutoresizingMaskIntoConstraints = false
            round.topAnchor.constraint(equalTo: labelBG.topAnchor, constant: 15).isActive = true
            round.leftAnchor.constraint(equalTo: labelBG.leftAnchor, constant: 10).isActive = true
            round.widthAnchor.constraint(equalToConstant: labelBG.frame.width * 0.2).isActive = true
            
            // Right
            let weekend = UILabel()
            let weekendText = getDates(startDay: "\(race.fp1.date)T\(race.fp1.time)", endDay: "\(race.race.date)T\(race.race.time)")
            let weekendArr = weekendText.components(separatedBy: " - ")
            weekend.text = "\n\(weekendArr[0])\n-\n\(weekendArr[1])\n"
            weekend.numberOfLines = 0
            weekend.frame.size = CGSize(width: labelBG.frame.width * 0.2, height: 50)
            weekend.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            weekend.textColor = .black
            weekend.textAlignment = .center
            weekend.layer.borderColor = #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1)
            weekend.layer.borderWidth = 2
            weekend.layer.cornerRadius = 8
            labelBG.addSubview(weekend)
            weekend.translatesAutoresizingMaskIntoConstraints = false
            weekend.topAnchor.constraint(equalTo: labelBG.topAnchor, constant: 15).isActive = true
            weekend.rightAnchor.constraint(equalTo: labelBG.rightAnchor, constant: -10).isActive = true
            weekend.widthAnchor.constraint(equalTo: round.widthAnchor).isActive = true
            weekend.heightAnchor.constraint(equalTo: round.heightAnchor).isActive = true
            
            // Middle
            let raceLocale = UILabel()
            raceLocale.numberOfLines = 0
            raceLocale.text = "\(race.country)"
            raceLocale.frame.size = CGSize(width: labelBG.frame.width * 0.6, height: 12.5)
            raceLocale.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            labelBG.addSubview(raceLocale)
            raceLocale.translatesAutoresizingMaskIntoConstraints = false
            raceLocale.topAnchor.constraint(equalTo: labelBG.topAnchor, constant: 18).isActive = true
            raceLocale.leftAnchor.constraint(equalTo: round.rightAnchor, constant: 15).isActive = true
            raceLocale.rightAnchor.constraint(equalTo: weekend.leftAnchor, constant: -15).isActive = true
            raceLocale.textColor = raceName.textColor

            raceName.text = "\(race.raceName)"
            raceName.frame.size = CGSize(width: labelBG.frame.width * 0.6, height: 18.5)
            raceName.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            raceName.numberOfLines = 2
            raceName.adjustsFontSizeToFitWidth = true
            labelBG.addSubview(raceName)
            raceName.translatesAutoresizingMaskIntoConstraints = false
            raceName.topAnchor.constraint(equalTo: raceLocale.bottomAnchor, constant: 10).isActive = true
            raceName.leftAnchor.constraint(equalTo: round.rightAnchor, constant: 15).isActive = true
            raceName.rightAnchor.constraint(equalTo: weekend.leftAnchor, constant: -15).isActive = true
            
            labelContainer.addSubview(timerView)
            labelContainer.addSubview(raceButt)
            labelView.addArrangedSubview(labelContainer)
            
            labelBG.center = labelContainer.center
        }
        
        scrollView.addSubview(labelView)
        
        if isNextRace {
            scrollView.contentOffset.y = CGFloat(scrollView.contentSize.height)
        } else {
            scrollView.contentOffset.y = CGFloat(offset)
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        guard let schedule = self.userDefaults?.value(forKey: "scheduleApp") as? [Data] else { return }
        let chosenRace = schedule[sender.tag]
        guard let raceInfo = try? JSONDecoder().decode(ScheduleInfo.self, from: chosenRace) else { return }
        guard let raceRaw = formatRace(raceInfo) else { return }
        guard let race = try? JSONDecoder().decode(IndividualRace.self, from: raceRaw) else { return }
        individualRace = race
        
        getResults(round: sender.tag + 1)
    }
    
    func getResults(round: Int) {
        if let url = URL(string: "https://ergast.com/api/f1/2022/\(round)/results.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleResult(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
        
    func handleResult(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard let testData = data else { return }
        guard let formData = try? JSONDecoder().decode(Results.self, from: testData) else { return }
        let result = formData.MRData.RaceTable.Races
        
        guard let safeRace = individualRace else { return }
        
        if result.count == 0 {
            DispatchQueue.main.async {
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FutureRaceView") as? FutureRaceViewController else { return }
                let nc = UINavigationController(rootViewController: viewController)
                viewController.trackInfo = safeRace
                self.present(nc, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PastRaceView") as? PastRaceViewController else { return }
                let nc = UINavigationController(rootViewController: viewController)
                viewController.trackInfo = safeRace
                viewController.results = result[0].Results
                self.present(nc, animated: true, completion: nil)
            }
        }

    }
    
    fileprivate func checkDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from:date)!
        
        let raceEnd = dateObj.addingTimeInterval(3 * 60 * 60)
        let todaysDate = Date()
        
        return todaysDate < raceEnd
    }
    
    fileprivate func formatRace(_ race: ScheduleInfo) -> Data? {
        
        let encoder = JSONEncoder()
        
        let images: [String]
        let weekend: String
        let s1: IndividualRaceSession
        let s2: IndividualRaceSession
        let s3: IndividualRaceSession
        let s4: IndividualRaceSession
        let main: IndividualRaceSession
        let mainRaw: Session
        
        images = widgetImages(race.raceName)
        weekend = getDates(startDay: "\(race.fp1.date)T\(race.fp1.time)", endDay: "\(race.race.date)T\(race.race.time)")
        
        s1 = IndividualRaceSession(name: "FP1", time: "\(getDay("\(race.fp1.date)")) \(getTime("\(race.fp1.date)T\(race.fp1.time)"))")
        
        if let thirdSess = race.fp3 {
            s2 = IndividualRaceSession(name: "FP2", time: "\(getDay("\(race.fp2.date)")) \(getTime("\(race.fp2.date)T\(race.fp2.time)"))")
            s3 = IndividualRaceSession(name: "FP3", time: "\(getDay("\(thirdSess.date)")) \(getTime("\(thirdSess.date)T\(thirdSess.time)"))")
            s4 = IndividualRaceSession(name: "Q1", time: "\(getDay("\(race.quali.date)")) \(getTime("\(race.quali.date)T\(race.quali.time)"))")
        } else {
            s2 = IndividualRaceSession(name: "Q1", time: "\(getDay("\(race.quali.date)")) \(getTime("\(race.quali.date)T\(race.quali.time)"))")
            s3 = IndividualRaceSession(name: "FP3", time: "\(getDay("\(race.fp2.date)")) \(getTime("\(race.fp2.date)T\(race.fp2.time)"))")
            s4 = IndividualRaceSession(name: "Sprint", time: "\(getDay("\(race.sprint!.date)")) \(getTime("\(race.sprint!.date)T\(race.sprint!.time)"))")
        }
        
        main = IndividualRaceSession(name: "Race", time: "\(getDay("\(race.race.date)")) \(getTime("\(race.race.date)T\(race.race.time)"))")
        mainRaw = Session(date: race.race.date, time: race.race.time)
        
        let widgetRace = IndividualRace(round: race.roundRaw, raceName: race.raceName, circuitName: race.circuitName, circuit: images[0], flag: images[1], weekend: weekend, s1: s1, s2: s2, s3: s3, s4: s4, race: main, raceRaw: mainRaw)
        
        guard let encoded = try? encoder.encode(widgetRace) else { return nil }
        
        return encoded
    }
    
    fileprivate func getDates(startDay: String, endDay: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startDayObj = dateFormatter.date(from:startDay)!
        let endDayObj = dateFormatter.date(from:endDay)!
        
        dateFormatter.dateFormat = "LLLL"
        var startMonth = dateFormatter.string(from: startDayObj)
        var endMonth = dateFormatter.string(from: endDayObj)
        let index = startMonth.index(startMonth.startIndex, offsetBy: 3)
        startMonth = String(startMonth[..<index])
        endMonth = String(endMonth[..<index])
        
        let start = Calendar.current.dateComponents([.day], from: startDayObj).day!
        let end = Calendar.current.dateComponents([.day], from: endDayObj).day!
        
        return "\(startMonth) \(start) - \(endMonth) \(end)"
    }
    
    fileprivate func getDay(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from:date)!
        
        let day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: dateObj) - 1]
        var formDay = String(day)
        let index = formDay.index(formDay.startIndex, offsetBy: 3)
        formDay = String(formDay[..<index])
        
        return formDay
    }
    
    fileprivate func getTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from:time)!
        
        dateFormatter.dateFormat = "h:mm a z"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: dateObj)
    }
    
    fileprivate func widgetImages(_ race: String) -> [String] {
        switch race {
        case "Bahrain Grand Prix":
            return ["bahraingp", "bahrain"]
        case "Saudi Arabian Grand Prix":
            return ["saudigp", "saudi"]
        case "Australian Grand Prix":
            return ["australia", "australiangp"]
        case "Emilia Romagna Grand Prix":
            return ["ergp", "italy"]
        case "Miami Grand Prix":
            return ["miamigp", "usa"]
        case "Spanish Grand Prix":
            return ["spanishgp", "spain"]
        case "Monaco Grand Prix":
            return ["monaco", "monaco"]
        case "Azerbaijan Grand Prix":
            return ["azerbaijangp", "azerbaijan"]
        case "Canadian Grand Prix":
            return ["canadiangp", "canada"]
        case "British Grand Prix":
            return ["britishgp", "britain"]
        case "Austrian Grand Prix":
            return ["austriangp", "austria"]
        case "French Grand Prix":
            return ["frenchgp", "france"]
        case "Hungarian Grand Prix":
            return ["hungariangp", "hungary"]
        case "Belgian Grand Prix":
            return ["belgiangp", "belgium"]
        case "Dutch Grand Prix":
            return ["dutchgp", "dutch"]
        case "Italian Grand Prix":
            return ["italiangp", "italy"]
        case "Singapore Grand Prix":
            return ["singaporegp", "singapore"]
        case "Japanese Grand Prix":
            return ["japanesegp", "japan"]
        case "United States Grand Prix":
            return ["usagp", "usa"]
        case "Mexico City Grand Prix":
            return ["mexicangp", "mexico"]
        case "Brazilian Grand Prix":
            return ["braziliangp", "brazil"]
        case "Abu Dhabi Grand Prix":
            return ["abudhabigp", "uae"]
        default:
            return []
        }
    }
    
    func setTimer(papaView: UIView, background: UIImageView, race: ScheduleInfo) {
        
        papaView.frame.size = CGSize(width: background.frame.width, height: CGFloat(100))
        papaView.backgroundColor = #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 0.3999521684)
        
        let timerStack = UIStackView()
        timerStack.frame.size = papaView.frame.size
        timerStack.center = papaView.center
        timerStack.distribution = .fillEqually
        
        // Week
        let weekView = UIView()
        weekView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        weekImage.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        weekImage.image = #imageLiteral(resourceName: "light")
        weekView.addSubview(weekImage)
        
        weekTimer.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        weekTimer.text = "00"
        weekTimer.textAlignment = .center
        weekTimer.font = UIFont(name: "Formula1-Display-Regular", size: 32)
        weekView.addSubview(weekTimer)
        
        let weekLabel = UILabel()
        weekLabel.text = "Weeks"
        weekLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
        weekView.addSubview(weekLabel)
        
        weekImage.translatesAutoresizingMaskIntoConstraints = false
        weekLabel.translatesAutoresizingMaskIntoConstraints = false
        weekImage.centerXAnchor.constraint(equalTo: weekView.centerXAnchor).isActive = true
        weekTimer.centerXAnchor.constraint(equalTo: weekView.centerXAnchor).isActive = true
        weekLabel.centerXAnchor.constraint(equalTo: weekView.centerXAnchor).isActive = true
        weekImage.topAnchor.constraint(equalTo: weekView.topAnchor, constant: 5).isActive = true
        weekTimer.topAnchor.constraint(equalTo: weekView.topAnchor, constant: 5).isActive = true
        weekLabel.topAnchor.constraint(equalTo: weekImage.bottomAnchor).isActive = true
        
        weekView.addTimerBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        timerStack.addArrangedSubview(weekView)
        
        
        // Day
        let dayView = UIView()
        dayView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        dayImage.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        dayImage.image = #imageLiteral(resourceName: "light")
        dayView.addSubview(dayImage)
        
        dayTimer.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        dayTimer.text = "00"
        dayTimer.textAlignment = .center
        dayTimer.font = UIFont(name: "Formula1-Display-Regular", size: 32)
        dayView.addSubview(dayTimer)
        
        let dayLabel = UILabel()
        dayLabel.text = "Days"
        dayLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
        dayView.addSubview(dayLabel)
        
        dayImage.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayImage.centerXAnchor.constraint(equalTo: dayView.centerXAnchor).isActive = true
        dayTimer.centerXAnchor.constraint(equalTo: dayView.centerXAnchor).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor).isActive = true
        dayImage.topAnchor.constraint(equalTo: dayView.topAnchor, constant: 5).isActive = true
        dayTimer.topAnchor.constraint(equalTo: dayView.topAnchor, constant: 5).isActive = true
        dayLabel.topAnchor.constraint(equalTo: dayImage.bottomAnchor).isActive = true
        
        dayView.addTimerBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        timerStack.addArrangedSubview(dayView)
        
        // Hour
        let hourView = UIView()
        hourView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        hourImage.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        hourImage.image = #imageLiteral(resourceName: "light")
        hourView.addSubview(hourImage)
        
        hourTimer.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        hourTimer.text = "00"
        hourTimer.textAlignment = .center
        hourTimer.font = UIFont(name: "Formula1-Display-Regular", size: 32)
        hourView.addSubview(hourTimer)
        
        let hourLabel = UILabel()
        hourLabel.text = "Hours"
        hourLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
        hourView.addSubview(hourLabel)
        
        hourImage.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourImage.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourTimer.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourLabel.centerXAnchor.constraint(equalTo: hourView.centerXAnchor).isActive = true
        hourImage.topAnchor.constraint(equalTo: hourView.topAnchor, constant: 5).isActive = true
        hourTimer.topAnchor.constraint(equalTo: hourView.topAnchor, constant: 5).isActive = true
        hourLabel.topAnchor.constraint(equalTo: hourImage.bottomAnchor).isActive = true
        
        hourView.addTimerBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        timerStack.addArrangedSubview(hourView)
        
        // minute
        let minView = UIView()
        minView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        minImage.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        minImage.image = #imageLiteral(resourceName: "light")
        minView.addSubview(minImage)
        
        minTimer.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        minTimer.text = "00"
        minTimer.textAlignment = .center
        minTimer.font = UIFont(name: "Formula1-Display-Regular", size: 32)
        minView.addSubview(minTimer)
        
        let minLabel = UILabel()
        minLabel.text = "Minutes"
        minLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
        minView.addSubview(minLabel)
        
        minImage.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        minImage.centerXAnchor.constraint(equalTo: minView.centerXAnchor).isActive = true
        minTimer.centerXAnchor.constraint(equalTo: minView.centerXAnchor).isActive = true
        minLabel.centerXAnchor.constraint(equalTo: minView.centerXAnchor).isActive = true
        minImage.topAnchor.constraint(equalTo: minView.topAnchor, constant: 5).isActive = true
        minTimer.topAnchor.constraint(equalTo: minView.topAnchor, constant: 5).isActive = true
        minLabel.topAnchor.constraint(equalTo: minImage.bottomAnchor).isActive = true
        
        minView.addTimerBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        timerStack.addArrangedSubview(minView)
        
        // second
        let secView = UIView()
        secView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        secImage.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        secImage.image = #imageLiteral(resourceName: "light")
        secView.addSubview(secImage)
        
        secTimer.frame.size = CGSize(width: background.frame.width / 5, height: 75)
        secTimer.text = "00"
        secTimer.textAlignment = .center
        secTimer.font = UIFont(name: "Formula1-Display-Regular", size: 32)
        secView.addSubview(secTimer)
        
        let secLabel = UILabel()
        secLabel.text = "Seconds"
        secLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
        secView.addSubview(secLabel)
        
        secImage.translatesAutoresizingMaskIntoConstraints = false
        secLabel.translatesAutoresizingMaskIntoConstraints = false
        secImage.centerXAnchor.constraint(equalTo: secView.centerXAnchor).isActive = true
        secTimer.centerXAnchor.constraint(equalTo: secView.centerXAnchor).isActive = true
        secLabel.centerXAnchor.constraint(equalTo: secView.centerXAnchor).isActive = true
        secImage.topAnchor.constraint(equalTo: secView.topAnchor, constant: 5).isActive = true
        secTimer.topAnchor.constraint(equalTo: secView.topAnchor, constant: 5).isActive = true
        secLabel.topAnchor.constraint(equalTo: secImage.bottomAnchor).isActive = true
        
        timerStack.addArrangedSubview(secView)
        
        papaView.addSubview(timerStack)
        
        weekImage.isHidden = true
        dayImage.isHidden = true
        hourImage.isHidden = true
        minImage.isHidden = true
        secImage.isHidden = true
        
        weekTimer.isHidden = false
        dayTimer.isHidden = false
        hourTimer.isHidden = false
        minTimer.isHidden = false
        secTimer.isHidden = false
        
        countdown = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let nowDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            guard let raceTime = dateFormatter.date(from: "\(race.race.date)T\(race.race.time)") else { return }
            
            let secondsRaw = Int(raceTime.timeIntervalSince(nowDate))
            let seconds = secondsRaw % 60
            
            let minutesRaw = secondsRaw / 60
            let minutes = minutesRaw % 60
            
            let hoursRaw = minutesRaw / 60
            let hours = hoursRaw % 24
            
            let daysRaw = hoursRaw / 24
            let days = daysRaw % 7
            
            let weeks =  daysRaw / 7
            
            DispatchQueue.main.async {
                self.secTimer.text = String(format: "%02d", seconds)
                self.minTimer.text = String(format: "%02d", minutes)
                self.hourTimer.text = String(format: "%02d", hours)
                self.dayTimer.text = String(format: "%02d", days)
                self.weekTimer.text = String(format: "%02d", weeks)
                
                self.weekTimer.isHidden = weeks <= 0 ? true : false
                self.weekImage.isHidden = weeks > 0 ? true : false
                
                if days <= 0 && daysRaw <= 0 {
                    self.dayTimer.isHidden = true
                    self.dayImage.isHidden = false
                } else {
                    self.dayTimer.isHidden = false
                    self.dayImage.isHidden = true
                }
                
                if hours <= 0 && hoursRaw <= 0 {
                    self.hourTimer.isHidden = true
                    self.hourImage.isHidden = false
                } else {
                    self.hourTimer.isHidden = false
                    self.hourImage.isHidden = true
                }
                
                if minutes <= 0 && minutesRaw <= 0 {
                    self.minTimer.isHidden = true
                    self.minImage.isHidden = false
                } else {
                    self.minTimer.isHidden = false
                    self.minImage.isHidden = true
                }
                
                if seconds <= 0 && secondsRaw <= 0 {
                    self.secTimer.isHidden = true
                    self.secImage.isHidden = false
                    timer.invalidate()
                } else {
                    self.secTimer.isHidden = false
                    self.secImage.isHidden = true
                }
            }
        }
        guard let safeCountdown = countdown else { return }
        safeCountdown.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let safeCountdown = countdown else { return }
        safeCountdown.invalidate()
    }
}

// MARK - Navigation
extension ScheduleViewController {
    @IBAction func navigateToConstructor(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConstructorView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func navigateToDriver(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}

extension UIView {
    
    func addTimerBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.maxX, y: (frame.minY + 20), width: thickness, height: frame.height / 2)
        
        layer.addSublayer(border)
    }
}
