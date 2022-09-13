//
//  RaceViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import UIKit

class FutureRaceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var raceLabel: UILabel!
    
    let trackImage = UIImageView()
    let flagImage = UIImageView()
    
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
    
    var trackInfo: IndividualRace? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let safeTrack = trackInfo else { return }
        raceLabel.text = safeTrack.raceName
        
        setTimes()
    }
    
    func setTimes() {
        
        guard let safeTrack = trackInfo else { return }
        setImages(safeTrack.raceName)
        let sessions: [IndividualRaceSession] = [safeTrack.s1, safeTrack.s2, safeTrack.s3, safeTrack.s4, safeTrack.race]
        
        scrollView.frame.size = CGSize(width: view.frame.width, height: scrollView.frame.height)
        
        var containerHeight = (scrollView.frame.width / 2) + 100 + 50
        containerHeight += (50 * CGFloat(sessions.count)) + (5 * (CGFloat(sessions.count) + 2))
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: containerHeight)
        
        let raceInfo = UIStackView()
        raceInfo.axis = .vertical
        raceInfo.spacing = 5
        raceInfo.frame.size = CGSize(width: scrollView.frame.width, height: containerHeight)
        
        let topContainers = UIStackView()
        topContainers.axis = .horizontal
        topContainers.distribution = .fillEqually
        topContainers.frame.size = CGSize(width: scrollView.frame.width, height: scrollView.frame.width / 2)
        
        // Track
        let trackContainer = UIView()
        trackContainer.frame.size = CGSize(width: scrollView.frame.width / 2, height: scrollView.frame.width / 2)
        trackContainer.addTrackBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let trackLabel = UILabel()
        trackLabel.frame.size = CGSize(width: trackContainer.frame.width - 16, height: trackContainer.frame.height / 10)
        trackLabel.text = safeTrack.circuitName
        trackLabel.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        trackLabel.textAlignment = .center
        trackLabel.numberOfLines = 0
        trackLabel.textColor = .black
        trackContainer.addSubview(trackLabel)
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.widthAnchor.constraint(equalToConstant: trackLabel.frame.width).isActive = true
        trackLabel.topAnchor.constraint(equalTo: trackContainer.topAnchor, constant: 15).isActive = true
        trackLabel.centerXAnchor.constraint(equalTo: trackContainer.centerXAnchor).isActive = true
        
        trackImage.frame.size = CGSize(width: trackContainer.frame.width - 15, height: trackContainer.frame.height - 15)
        trackContainer.addSubview(trackImage)
        trackImage.translatesAutoresizingMaskIntoConstraints = false
        trackImage.heightAnchor.constraint(equalToConstant: trackImage.frame.height).isActive = true
        trackImage.widthAnchor.constraint(equalToConstant: trackImage.frame.width).isActive = true
        trackImage.centerXAnchor.constraint(equalTo: trackContainer.centerXAnchor).isActive = true
        trackImage.bottomAnchor.constraint(equalTo: trackContainer.bottomAnchor, constant: 8).isActive = true
        
        topContainers.addArrangedSubview(trackContainer)
        
        // Flag and weekend
        let flagContainer = UIView()
        flagContainer.frame.size = CGSize(width: scrollView.frame.width / 2, height: scrollView.frame.width / 2)
        
        flagImage.frame.size = CGSize(width: flagContainer.frame.width * 0.6, height: flagContainer.frame.width * 0.36)
        flagContainer.addSubview(flagImage)
        flagImage.translatesAutoresizingMaskIntoConstraints = false
        flagImage.heightAnchor.constraint(equalToConstant: trackImage.frame.height).isActive = true
        flagImage.widthAnchor.constraint(equalToConstant: trackImage.frame.width).isActive = true
        flagImage.centerXAnchor.constraint(equalTo: flagContainer.centerXAnchor).isActive = true
        flagImage.topAnchor.constraint(equalTo: flagContainer.topAnchor, constant: -12).isActive = true
        
        let weekendLabel = UILabel()
        weekendLabel.frame.size = CGSize(width: flagContainer.frame.width - 16, height: flagContainer.frame.height / 10)
        weekendLabel.text = safeTrack.weekend
        weekendLabel.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = .black
        weekendLabel.numberOfLines = 0
        flagContainer.addSubview(weekendLabel)
        weekendLabel.translatesAutoresizingMaskIntoConstraints = false
        weekendLabel.centerXAnchor.constraint(equalTo: flagContainer.centerXAnchor).isActive = true
        weekendLabel.topAnchor.constraint(equalTo: flagImage.bottomAnchor, constant: -5).isActive = true
        
        topContainers.addArrangedSubview(flagContainer)
        
        // Race countdown
        let timerContainer = UIView()
        timerContainer.frame.size = CGSize(width: scrollView.frame.width, height: 100)
        timerContainer.layer.borderColor = #colorLiteral(red: 0.7945286036, green: 0.3097311854, blue: 0.08659250289, alpha: 1)
        timerContainer.layer.borderWidth = 4
        
        let timerView = UIView()
        timerView.frame.size = timerContainer.frame.size
        setTimer(papaView: timerView, race: safeTrack)
        
        timerContainer.addSubview(timerView)
        
        // "Times" Label
        let timeTitleContainer = UIView()
        timeTitleContainer.frame.size = CGSize(width: scrollView.frame.width, height: 50)
        timeTitleContainer.addTimeBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let timeTitle = UILabel()
        timeTitle.frame.size = timeTitleContainer.frame.size
        timeTitle.text = "Session Times"
        timeTitle.font = UIFont(name: "Formula1-Display-Regular", size: 24)
        timeTitle.textColor = .black
        timeTitle.textAlignment = .center
        
        timeTitleContainer.addSubview(timeTitle)
        
        raceInfo.addArrangedSubview(topContainers)
        raceInfo.addArrangedSubview(timerContainer)
        raceInfo.addArrangedSubview(timeTitleContainer)
        timerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timeTitleContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Actual Times
        for session in sessions {
            let sessionTimeContainer = UIView()
            sessionTimeContainer.frame.size = CGSize(width: scrollView.frame.width, height: 50)
            sessionTimeContainer.addTimeBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
            
            let sessionName = UILabel()
            sessionName.frame.size = CGSize(width: sessionTimeContainer.frame.width * 0.3, height: sessionTimeContainer.frame.height)
            sessionName.text = "\(session.name):"
            sessionName.textAlignment = .left
            sessionName.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            sessionName.textColor = .black
            
            sessionTimeContainer.addSubview(sessionName)
            sessionName.translatesAutoresizingMaskIntoConstraints = false
            sessionName.leadingAnchor.constraint(equalTo: sessionTimeContainer.leadingAnchor, constant: 20).isActive = true
            
            let sessionTime = UILabel()
            sessionTime.frame.size = CGSize(width: sessionTimeContainer.frame.width * 0.7, height: sessionTimeContainer.frame.height)
            sessionTime.text = "\(session.time)"
            sessionTime.textAlignment = .right
            sessionTime.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            sessionTime.textColor = .black
            
            sessionTimeContainer.addSubview(sessionTime)
            sessionTime.translatesAutoresizingMaskIntoConstraints = false
            sessionTime.trailingAnchor.constraint(equalTo: sessionTimeContainer.trailingAnchor, constant: -20).isActive = true
            
            raceInfo.addArrangedSubview(sessionTimeContainer)
            sessionTimeContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        scrollView.addSubview(raceInfo)
    }
    
    func getDates(startDay: String, endDay: String) -> String {
        
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
    
    func getSession(_ session: String) -> String {
        switch(session) {
        case "FirstPractice":
            return "FP1"
        case "SecondPractice":
            return "FP2"
        case "ThirdPractice":
            return "FP3"
        case "Qualifying":
            return "Q1"
        default:
            return "Sprint"
        }
    }
    
    func getDay(_ date: String) -> String {
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
    
    func getTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from:time)!
        
        dateFormatter.dateFormat = "h:mm a z"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: dateObj)
    }
    
    func setImages(_ raceName: String) {
        switch raceName {
        case "Bahrain Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "bahraingp")
            flagImage.image = #imageLiteral(resourceName: "bahrain")
        case "Saudi Arabian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "saudigp")
            flagImage.image = #imageLiteral(resourceName: "saudi")
        case "Australian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "australiangp")
            flagImage.image = #imageLiteral(resourceName: "australia")
        case "Emilia Romagna Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "ergp")
            flagImage.image = #imageLiteral(resourceName: "italy")
        case "Miami Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "miamigp")
            flagImage.image = #imageLiteral(resourceName: "usa")
        case "Spanish Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "spanishgp")
            flagImage.image = #imageLiteral(resourceName: "spain")
        case "Monaco Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "monacogp")
            flagImage.image = #imageLiteral(resourceName: "monaco")
        case "Azerbaijan Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "azerbaijangp")
            flagImage.image = #imageLiteral(resourceName: "azerbaijan")
        case "Canadian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "canadiangp")
            flagImage.image = #imageLiteral(resourceName: "canada")
        case "British Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "britishgp")
            flagImage.image = #imageLiteral(resourceName: "britain")
        case "Austrian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "austriangp")
            flagImage.image = #imageLiteral(resourceName: "austria")
        case "French Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "frenchgp")
            flagImage.image = #imageLiteral(resourceName: "france")
        case "Hungarian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "hungariangp")
            flagImage.image = #imageLiteral(resourceName: "hungary")
        case "Belgian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "belgiangp")
            flagImage.image = #imageLiteral(resourceName: "belgium")
        case "Dutch Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "dutchgp")
            flagImage.image = #imageLiteral(resourceName: "dutch")
        case "Italian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "italiangp")
            flagImage.image = #imageLiteral(resourceName: "italy")
        case "Singapore Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "singaporegp")
            flagImage.image = #imageLiteral(resourceName: "singapore")
        case "Japanese Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "japanesegp")
            flagImage.image = #imageLiteral(resourceName: "japan")
        case "United States Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "usagp")
            flagImage.image = #imageLiteral(resourceName: "usa")
        case "Mexico City Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "mexicangp")
            flagImage.image = #imageLiteral(resourceName: "mexico")
        case "Brazilian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "braziliangp")
            flagImage.image = #imageLiteral(resourceName: "brazil")
        case "Abu Dhabi Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "abudhabigp")
            flagImage.image = #imageLiteral(resourceName: "uae")
        default:
            break
        }
    }
    
    func setTimer(papaView: UIView, race: IndividualRace) {
        
        papaView.backgroundColor = #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 0.3999521684)
        
        let timerStack = UIStackView()
        timerStack.frame.size = papaView.frame.size
        timerStack.center = papaView.center
        timerStack.distribution = .fillEqually
        
        // Week
        let weekView = UIView()
        weekView.frame.size = CGSize(width: papaView.frame.width / 5, height: papaView.frame.height)
        
        weekImage.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
        weekImage.image = #imageLiteral(resourceName: "light")
        weekView.addSubview(weekImage)
        
        weekTimer.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
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
        
        dayImage.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
        dayImage.image = #imageLiteral(resourceName: "light")
        dayView.addSubview(dayImage)
        
        dayTimer.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
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
        
        hourImage.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
        hourImage.image = #imageLiteral(resourceName: "light")
        hourView.addSubview(hourImage)
        
        hourTimer.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
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
        
        minImage.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
        minImage.image = #imageLiteral(resourceName: "light")
        minView.addSubview(minImage)
        
        minTimer.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
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
        
        secImage.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
        secImage.image = #imageLiteral(resourceName: "light")
        secView.addSubview(secImage)
        
        secTimer.frame.size = CGSize(width: papaView.frame.width / 5, height: 75)
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
            guard let raceTime = dateFormatter.date(from: "\(race.raceRaw.date)T\(race.raceRaw.time)") else { return }
            
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

extension UIView {
    
    func addTrackBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.maxX - (thickness / 2), y: (frame.minY + (frame.midY / 4)), width: thickness, height: frame.height * 0.75)
        
        layer.addSublayer(border)
    }
    
    func addTimeBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX, y: frame.maxY - 10, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
}
