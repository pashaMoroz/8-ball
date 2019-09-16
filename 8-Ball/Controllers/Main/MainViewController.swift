//
//  MainView.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Spring
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak private var ballImage: SpringImageView!
    @IBOutlet weak private var answerLabel: SpringLabel!
    @IBOutlet weak private var shakeIcon: SpringImageView!
    
    private var answers = [NSManagedObject]()
    private let dataService = DataService()
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Magic Ball"
        shakeIconAnimation(shake: true)
        settingNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataService.fetchRequest()
        answers = dataService.answers
    }
    
    
    // MARK: - UIEvent
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        settingsForMotionBegan()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        fillingsAnswer()
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //fillingsAnswerFromTheInternet()
        shakeIconAnimation(shake: true)
    }
    
    
    // MARK: - Networking
    
    private func fillingsAnswer() {
        
        if NetworkState().isConnected {
            let networkManager = NetworkManager()
            networkManager.fetchData(url: networkManager.link) { [weak self] (data) in
                if data == nil {
                    self?.randomAnswers()
                } else {
                    self?.answerLabel.text = data?.magic.answer
                }
            }
        } else {
            randomAnswers()
        }
        self.ballImage.stopAnimating()
    }
    
    private func randomAnswers() {
        if answers.isEmpty == true {
            answerLabel?.text = "you're lucky!"
        } else {
            let chooseAnswer = answers.randomElement 
            answerLabel?.text = chooseAnswer()!.value(forKeyPath: "custAnswer") as? String
        }
    }
    
    
    // MARK: - Settings for UIEvent
    
    private func settingsForMotionBegan() {
        
        shakeIconAnimation(shake: false)
        
        ballImage.animation = "wobble"
        ballImage.animate()
        
        answerLabel.animation = "fadeInRight"
        answerLabel.animate()
        answerLabel.text = "wait.."
    }
    
    private func shakeIconAnimation(shake: Bool) {
        
        if shake {
            shakeIcon.animation = "shake"
            shakeIcon.repeatCount = 999
            shakeIcon.animate()
            shakeIcon.isHidden = false
            answerLabel.text = "Ask a question and shake.."
        } else {
            shakeIcon.stopAnimating()
            shakeIcon.isHidden = true
        }
    }
    
    
    // MARK: - Settings Navigation Bar
    
    private func settingNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingsTap))
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    // MARK: - Navigation
    
    @objc private func settingsTap() {
        
        let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

