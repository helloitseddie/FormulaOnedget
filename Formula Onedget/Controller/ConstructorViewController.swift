//
//  ConstructorViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import UIKit

class ConstructorViewController: UIViewController {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var driverButt: UIButton!
    @IBOutlet weak var constButt: UIButton!
    @IBOutlet weak var scheduleButt: UIButton!
    @IBOutlet weak var plsButt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverButt.imageView?.alpha = 0.5
        constButt.imageView?.alpha = 1
        scheduleButt.imageView?.alpha = 0.5
        plsButt.imageView?.alpha = 0.5
        
        let constructorBrain = ConstructorBrain()
        constructorBrain.getConstructors()
        
        setConstructors()
    }
    
    fileprivate func setConstructors() {
        guard let constructorStandings = self.userDefaults?.value(forKey: "constructorStandingsWithDrivers") as? [[String]] else { return }
        
        let containerHeight: Float = (100.0 * Float(constructorStandings.count)) + (5.0 * Float(constructorStandings.count))
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
        var constStack: UIStackView
        var constLabel: UILabel
        var flagView: UIImageView
        var pointsLabel: UILabel
        
        for constructorRaw in constructorStandings {
            
            let constructor = ConstructorInfo(data: constructorRaw)
            
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
            posLabel.text = "\(constructor.position)"
            posLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            posLabel.textColor = .black
            posLabel.textAlignment = .left
            labelStack.addArrangedSubview(posLabel)
            
            let teamColor = UIProgressView()
            teamColor.frame.size = CGSize(width: CGFloat(10), height: CGFloat(50))
            teamColor.widthAnchor.constraint(equalToConstant: CGFloat(labelContainer.frame.width / 50)).isActive = true
            teamColor.progressTintColor = constructor.constructorColor
            teamColor.progress = 1
            labelStack.addArrangedSubview(teamColor)
            
            constStack = UIStackView()
            constStack.axis = .vertical
            constStack.frame.size = labelStack.frame.size
            constStack.distribution = .fillEqually
            
            constLabel = UILabel()
            constLabel.text = "    \(constructor.name)"
            constLabel.font = UIFont(name: "Formula1-Display-Regular", size: 18)
            constLabel.textColor = .black
            constLabel.textAlignment = .left
            
            let flagStack = UIStackView()
            flagStack.frame.size = CGSize(width: constLabel.frame.width, height: CGFloat(25))
            flagStack.axis = .horizontal
            flagStack.distribution = .fill
            
            let leftPadLabel = UILabel()
            leftPadLabel.frame.size = CGSize(width: 20, height: CGFloat(25))
            leftPadLabel.widthAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
            leftPadLabel.text = "     "
            leftPadLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
            leftPadLabel.adjustsFontSizeToFitWidth = true
            flagStack.addArrangedSubview(leftPadLabel)
            
            flagView = UIImageView()
            flagView.frame.size = CGSize(width: CGFloat(23), height: CGFloat(12))
            flagView.widthAnchor.constraint(equalToConstant: CGFloat(23)).isActive = true
            flagView.image = UIImage(named: constructor.constructorFlag)
            flagView.contentMode = .scaleAspectFit
            flagStack.addArrangedSubview(flagView)
            
            let driversLabel = UILabel()
            driversLabel.frame.size = CGSize(width: flagStack.frame.width - 43, height: CGFloat(25))
            driversLabel.text = "    \(constructor.drivers.joined(separator: " / "))"
            driversLabel.font = UIFont(name: "Formula1-Display-Regular", size: 12)
            driversLabel.textColor = .black
            driversLabel.adjustsFontSizeToFitWidth = true
            flagStack.addArrangedSubview(driversLabel)

            constStack.addArrangedSubview(constLabel)
            constStack.addArrangedSubview(flagStack)
            
            labelStack.addArrangedSubview(constStack)

            pointsLabel = UILabel()
            pointsLabel.text = "\(constructor.points)PTS"
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
extension ConstructorViewController {
    @IBAction func navigateToDriver(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @IBAction func navigateToSchedule(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}
