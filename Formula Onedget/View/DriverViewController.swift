//
//  DriverViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import UIKit

class DriverViewController: UIViewController {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var driverButt: UIButton!
    @IBOutlet weak var constButt: UIButton!
    @IBOutlet weak var scheduleButt: UIButton!
    @IBOutlet weak var plsButt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverButt.imageView?.alpha = 1
        constButt.imageView?.alpha = 0.5
        scheduleButt.imageView?.alpha = 0.5
        plsButt.imageView?.alpha = 0.5
        
        let driverBrain = DriverBrain()
        driverBrain.getDrivers()
        
        setDrivers()
    }
    
    fileprivate func setDrivers() {
        guard let driverStandings = self.userDefaults?.value(forKey: "driverStandings") as? [[String]] else { return }
        
        let containerHeight: Float = (100.0 * Float(driverStandings.count)) + (5.0 * Float(driverStandings.count))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        var labelContainer: UIView
        var labelBG: UIImageView
        var labelStack: UIStackView
        var posLabel: UILabel
        var driverStack: UIStackView
        var driverLabel: UILabel
        var teamLabel: UILabel
        var pointsLabel: UILabel
        
        for rawDriver in driverStandings {
            
            let driver = DriverInfo(data: rawDriver)
            
            labelContainer = UIView()
            labelContainer.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
            
            labelBG = UIImageView()
            labelBG.frame.size = CGSize(width: scrollView.contentSize.width - 20, height: labelContainer.frame.height)
            labelBG.center = labelContainer.center
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            
            labelStack = UIStackView()
            labelStack.frame.size = CGSize(width: labelContainer.frame.width - 40, height: CGFloat(50))
            labelStack.axis = .horizontal
            labelStack.distribution = .fillProportionally
            labelStack.center = labelContainer.center
            
            posLabel = UILabel()
            posLabel.frame.size = CGSize(width: CGFloat(50), height: labelStack.frame.height)
            posLabel.widthAnchor.constraint(equalToConstant: CGFloat(labelContainer.frame.width / 10)).isActive = true
            
            posLabel.text = "\(driver.position)"
            posLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            posLabel.textColor = .black
            posLabel.textAlignment = .left
            labelStack.addArrangedSubview(posLabel)
            
            let teamColor = UIProgressView()
            teamColor.frame.size = CGSize(width: CGFloat(10), height: CGFloat(50))
            teamColor.widthAnchor.constraint(equalToConstant: CGFloat(labelContainer.frame.width / 50)).isActive = true
            teamColor.progressTintColor = driver.constructorColor
            teamColor.progress = 1
            labelStack.addArrangedSubview(teamColor)
            
            driverStack = UIStackView()
            driverStack.axis = .vertical
            driverStack.frame.size = labelStack.frame.size
            driverStack.distribution = .fillProportionally
            
            driverLabel = UILabel()
            driverLabel.text = "    \(driver.fullName)"
            driverLabel.font = UIFont(name: "Formula1-Display-Regular", size: 18)
            driverLabel.textColor = .black
            driverLabel.textAlignment = .left
            
            teamLabel = UILabel()
            teamLabel.text = "      \(driver.constructor)"
            teamLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
            teamLabel.textColor = .black
            teamLabel.textAlignment = .left

            driverStack.addArrangedSubview(driverLabel)
            driverStack.addArrangedSubview(teamLabel)
            
            labelStack.addArrangedSubview(driverStack)

            pointsLabel = UILabel()
            pointsLabel.text = "\(driver.points)PTS"
            pointsLabel.font = UIFont(name: "Formula1-Display-Regular", size: 18)
            pointsLabel.textColor = .black
            pointsLabel.textAlignment = .right
            pointsLabel.widthAnchor.constraint(equalToConstant: CGFloat(labelContainer.frame.width / 4)).isActive = true

            labelStack.addArrangedSubview(pointsLabel)
            
            labelContainer.addSubview(labelBG)
            labelContainer.addSubview(labelStack)
            
            labelView.addArrangedSubview(labelContainer)
        }
        
        scrollView.addSubview(labelView)
    }
    
}

// MARK - Navigation
extension DriverViewController {
    @IBAction func navigateToConstructor(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConstructorView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @IBAction func navigateToSchedule(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}
