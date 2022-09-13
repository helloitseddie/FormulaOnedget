//
//  PastRaceViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 9/13/22.
//

import UIKit

class PastRaceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var raceLabel: UILabel!
    
    let trackImage = UIImageView()
    let flagImage = UIImageView()
    
    var trackInfo: IndividualRace? = nil
    var results: [Result?] = []
    
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
        
        let containerHeight = (scrollView.frame.width) + 100 + CGFloat(results.count * 50) + CGFloat(5 * results.count)
        
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
        trackContainer.addTestBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
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
        flagContainer.addTestBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
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
        
        // Middle
        let midContainers = UIStackView()
        midContainers.axis = .horizontal
        midContainers.distribution = .fillEqually
        midContainers.frame.size = CGSize(width: scrollView.frame.width, height: scrollView.frame.width / 2)
        midContainers.heightAnchor.constraint(equalToConstant: midContainers.frame.height).isActive = true
        midContainers.widthAnchor.constraint(equalToConstant: midContainers.frame.width).isActive = true
        
        // Podium
        let podiumContainer = UIView()
        podiumContainer.frame.size = CGSize(width: midContainers.frame.width / 2, height: midContainers.frame.height)
        midContainers.addArrangedSubview(podiumContainer)
        podiumContainer.addTestBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let podiumLabel = UILabel()
        podiumLabel.frame.size = CGSize(width: podiumContainer.frame.width, height: podiumContainer.frame.width / 5)
        podiumLabel.text = "Podium"
        podiumLabel.textAlignment = .center
        podiumLabel.font = UIFont(name: "Formula1-Display-Regular", size: 18)
        podiumContainer.addSubview(podiumLabel)
        podiumLabel.translatesAutoresizingMaskIntoConstraints = false
        podiumLabel.widthAnchor.constraint(equalToConstant: podiumLabel.frame.width).isActive = true
        podiumLabel.heightAnchor.constraint(equalToConstant: podiumLabel.frame.height).isActive = true
        podiumLabel.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor).isActive = true
        podiumLabel.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: 10).isActive = true
        
        let firstLabel = UILabel()
        firstLabel.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        firstLabel.text = "1"
        firstLabel.textAlignment = .center
        firstLabel.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(firstLabel)
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.widthAnchor.constraint(equalToConstant: firstLabel.frame.width).isActive = true
        firstLabel.heightAnchor.constraint(equalToConstant: firstLabel.frame.height).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor).isActive = true
        firstLabel.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: podiumContainer.frame.height * 0.4).isActive = true
        firstLabel.addPodiumBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let firstDriver = UILabel()
        firstDriver.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        guard let safeFirstDriver = results[0] else { return }
        firstDriver.text = safeFirstDriver.Driver.code
        firstDriver.textAlignment = .center
        firstDriver.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(firstDriver)
        firstDriver.translatesAutoresizingMaskIntoConstraints = false
        firstDriver.widthAnchor.constraint(equalToConstant: firstDriver.frame.width).isActive = true
        firstDriver.heightAnchor.constraint(equalToConstant: firstDriver.frame.height).isActive = true
        firstDriver.centerXAnchor.constraint(equalTo: firstLabel.centerXAnchor).isActive = true
        firstDriver.bottomAnchor.constraint(equalTo: firstLabel.topAnchor).isActive = true
        
        let secondLabel = UILabel()
        secondLabel.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        secondLabel.text = "2"
        secondLabel.textAlignment = .center
        secondLabel.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(secondLabel)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.widthAnchor.constraint(equalToConstant: secondLabel.frame.width).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: secondLabel.frame.height).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor, constant: -podiumContainer.frame.width * 0.25).isActive = true
        secondLabel.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: podiumContainer.frame.height * 0.7).isActive = true
        secondLabel.addPodiumBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let secondDriver = UILabel()
        secondDriver.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        guard let safeSecondDriver = results[1] else { return }
        secondDriver.text = safeSecondDriver.Driver.code
        secondDriver.textAlignment = .center
        secondDriver.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(secondDriver)
        secondDriver.translatesAutoresizingMaskIntoConstraints = false
        secondDriver.widthAnchor.constraint(equalToConstant: secondDriver.frame.width).isActive = true
        secondDriver.heightAnchor.constraint(equalToConstant: secondDriver.frame.height).isActive = true
        secondDriver.centerXAnchor.constraint(equalTo: secondLabel.centerXAnchor).isActive = true
        secondDriver.bottomAnchor.constraint(equalTo: secondLabel.topAnchor).isActive = true
        
        let thirdLabel = UILabel()
        thirdLabel.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        thirdLabel.text = "3"
        thirdLabel.textAlignment = .center
        thirdLabel.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(thirdLabel)
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.widthAnchor.constraint(equalToConstant: thirdLabel.frame.width).isActive = true
        thirdLabel.heightAnchor.constraint(equalToConstant: thirdLabel.frame.height).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor, constant: podiumContainer.frame.width * 0.25).isActive = true
        thirdLabel.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: podiumContainer.frame.height * 0.8).isActive = true
        thirdLabel.addPodiumBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let thirdDriver = UILabel()
        thirdDriver.frame.size = CGSize(width: podiumContainer.frame.width / 4, height: podiumContainer.frame.width / 10)
        guard let safeThirdDriver = results[2] else { return }
        thirdDriver.text = safeThirdDriver.Driver.code
        thirdDriver.textAlignment = .center
        thirdDriver.font = UIFont(name: "Formula1-Display-Regular", size: 16)
        podiumContainer.addSubview(thirdDriver)
        thirdDriver.translatesAutoresizingMaskIntoConstraints = false
        thirdDriver.widthAnchor.constraint(equalToConstant: thirdDriver.frame.width).isActive = true
        thirdDriver.heightAnchor.constraint(equalToConstant: thirdDriver.frame.height).isActive = true
        thirdDriver.centerXAnchor.constraint(equalTo: thirdLabel.centerXAnchor).isActive = true
        thirdDriver.bottomAnchor.constraint(equalTo: thirdLabel.topAnchor).isActive = true
        
        // Times
        let timeContainer = UIView()
        timeContainer.frame.size = CGSize(width: midContainers.frame.width / 2, height: midContainers.frame.height)
        timeContainer.addContainerBorder(withColor:  #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        
        let timeLabel = UILabel()
        timeLabel.frame.size = CGSize(width: timeContainer.frame.width, height: timeContainer.frame.height * 0.2)
        timeLabel.text = "Times"
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "Formula1-Display-Regular", size: 18)
        timeContainer.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.widthAnchor.constraint(equalToConstant: timeLabel.frame.width).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.frame.height).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeContainer.topAnchor, constant: 10).isActive = true
        
        let timeView = UIStackView()
        timeView.frame.size = CGSize(width: timeContainer.frame.width, height: timeContainer.frame.height * 0.8)
        timeView.axis = .vertical
        timeView.distribution = .fillEqually
        timeContainer.addSubview(timeView)
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        timeView.leftAnchor.constraint(equalTo: timeContainer.leftAnchor).isActive = true
        
        for session in sessions {
            let sessionTimeContainer = UIView()
            sessionTimeContainer.frame.size = CGSize(width: timeView.frame.width, height: timeView.frame.height / 5)
            sessionTimeContainer.addTimeBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
            
            let sessionName = UILabel()
            sessionName.frame.size = CGSize(width: sessionTimeContainer.frame.width * 0.3, height: sessionTimeContainer.frame.height)
            sessionName.text = "\(session.name):"
            sessionName.textAlignment = .left
            sessionName.font = UIFont(name: "Formula1-Display-Regular", size: 12)
            sessionName.textColor = .black
            
            sessionTimeContainer.addSubview(sessionName)
            sessionName.translatesAutoresizingMaskIntoConstraints = false
            sessionName.leadingAnchor.constraint(equalTo: sessionTimeContainer.leadingAnchor, constant: 10).isActive = true
            
            let sessionTime = UILabel()
            sessionTime.frame.size = CGSize(width: sessionTimeContainer.frame.width * 0.7, height: sessionTimeContainer.frame.height)
            sessionTime.text = "\(session.time)"
            sessionTime.textAlignment = .right
            sessionTime.font = UIFont(name: "Formula1-Display-Regular", size: 12)
            sessionTime.textColor = .black
            
            sessionTimeContainer.addSubview(sessionTime)
            
            timeView.addArrangedSubview(sessionTimeContainer)
            sessionTime.translatesAutoresizingMaskIntoConstraints = false
            sessionTime.trailingAnchor.constraint(equalTo: timeContainer.trailingAnchor, constant: -10).isActive = true
            sessionTimeContainer.heightAnchor.constraint(equalToConstant: timeView.frame.height / 5).isActive = true
            sessionTimeContainer.centerXAnchor.constraint(equalTo: timeView.centerXAnchor).isActive = true
        }
        
        midContainers.addArrangedSubview(timeContainer)
        
        let timeTitleContainer = UIView()
        timeTitleContainer.frame.size = CGSize(width: scrollView.frame.width, height: 50)
        timeTitleContainer.heightAnchor.constraint(equalToConstant: timeTitleContainer.frame.height).isActive = true
        
        let timeTitle = UILabel()
        timeTitle.frame.size = timeTitleContainer.frame.size
        timeTitle.text = "Race Results"
        timeTitle.font = UIFont(name: "Formula1-Display-Regular", size: 24)
        timeTitle.textColor = .black
        timeTitle.textAlignment = .center
        
        timeTitleContainer.addSubview(timeTitle)
        
        let resultsExplanationContainer = UIView()
        resultsExplanationContainer.frame.size = CGSize(width: scrollView.frame.width, height: 50)
        resultsExplanationContainer.addTimeBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
        resultsExplanationContainer.heightAnchor.constraint(equalToConstant: resultsExplanationContainer.frame.height).isActive = true
        
        let pos = UILabel()
        pos.frame.size = resultsExplanationContainer.frame.size
        pos.text = "Pos."
        pos.font = UIFont(name: "Formula1-Display-Regular", size: 24)
        pos.textColor = .black
        pos.textAlignment = .center
        resultsExplanationContainer.addSubview(pos)
        pos.translatesAutoresizingMaskIntoConstraints = false
        pos.leadingAnchor.constraint(equalTo: resultsExplanationContainer.leadingAnchor, constant: 20).isActive = true
        
        let name = UILabel()
        name.frame.size = resultsExplanationContainer.frame.size
        name.text = "Name"
        name.font = UIFont(name: "Formula1-Display-Regular", size: 24)
        name.textColor = .black
        name.textAlignment = .center
        resultsExplanationContainer.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerXAnchor.constraint(equalTo: resultsExplanationContainer.centerXAnchor).isActive = true
        
        let pts = UILabel()
        pts.frame.size = resultsExplanationContainer.frame.size
        pts.text = "Pts."
        pts.font = UIFont(name: "Formula1-Display-Regular", size: 24)
        pts.textColor = .black
        pts.textAlignment = .center
        resultsExplanationContainer.addSubview(pts)
        pts.translatesAutoresizingMaskIntoConstraints = false
        pts.trailingAnchor.constraint(equalTo: resultsExplanationContainer.trailingAnchor, constant: -20).isActive = true
        
        raceInfo.addArrangedSubview(topContainers)
        raceInfo.addArrangedSubview(midContainers)
        raceInfo.addArrangedSubview(timeTitleContainer)
        raceInfo.addArrangedSubview(resultsExplanationContainer)
        
        // Actual Times
        for result in results {
            guard let safeResult = result else { return }
            
            let resultContainer = UIView()
            resultContainer.frame.size = CGSize(width: scrollView.frame.width, height: 50)
            resultContainer.addTimeBorder(withColor: #colorLiteral(red: 0, green: 0.2951171398, blue: 0.3895429075, alpha: 1), andThickness: 2)
            
            let driverPos = UILabel()
            driverPos.frame.size = CGSize(width: resultContainer.frame.width * 0.3, height: resultContainer.frame.height)
            driverPos.text = "\(safeResult.positionText == "R" ? "DNF" : safeResult.positionText + ".")"
            driverPos.textAlignment = .left
            driverPos.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            driverPos.textColor = .black

            resultContainer.addSubview(driverPos)
            driverPos.translatesAutoresizingMaskIntoConstraints = false
            driverPos.leadingAnchor.constraint(equalTo: resultContainer.leadingAnchor, constant: 20).isActive = true

            let driverName = UILabel()
            driverName.frame.size = CGSize(width: resultContainer.frame.width * 0.3, height: resultContainer.frame.height)
            driverName.text = "\(safeResult.Driver.familyName)"
            driverName.textAlignment = .left
            driverName.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            driverName.textColor = .black

            resultContainer.addSubview(driverName)
            driverName.translatesAutoresizingMaskIntoConstraints = false
            driverName.centerXAnchor.constraint(equalTo: resultContainer.centerXAnchor).isActive = true

            let driverPoints = UILabel()
            driverPoints.frame.size = CGSize(width: resultContainer.frame.width * 0.7, height: resultContainer.frame.height)
            driverPoints.text = "\(safeResult.points)"
            driverPoints.textAlignment = .right
            driverPoints.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            driverPoints.textColor = .black

            resultContainer.addSubview(driverPoints)
            driverPoints.translatesAutoresizingMaskIntoConstraints = false
            driverPoints.trailingAnchor.constraint(equalTo: resultContainer.trailingAnchor, constant: -20).isActive = true

            raceInfo.addArrangedSubview(resultContainer)
            resultContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

}

extension UIView {
    
    func addPodiumBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
    
    func addContainerBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX + (frame.width * 0.125), y: frame.maxY, width: frame.width * 0.75, height: thickness)
        
        layer.addSublayer(border)
    }
    
    func addDriverBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX, y: frame.maxY - 10, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
    
    func addTestBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
}

