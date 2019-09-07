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
    
    @IBOutlet weak var ballImage: SpringImageView!
    @IBOutlet weak var answerLabel: SpringLabel!
    @IBOutlet weak var shakeIcon: SpringImageView!
    
    private var answers = [NSManagedObject]()
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Magic Ball"
        shakeIconAnimation(shake: true)
        settingNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustAnswer")
        
        do {
            answers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - UIEvent
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        settingsForMotionBegan()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        fillingsAnswerFromTheInternet()
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //fillingsAnswerFromTheInternet()
        shakeIconAnimation(shake: true)
    }
    
    
    // MARK: - Networking
    
    private func fillingsAnswerFromTheInternet() {
        
        if NetworkState().isConnected {
            NetworkManager.shared.fetchDataWithAlamofire(url: NetworkManager.shared.link) { [weak self] (data) in
                self?.answerLabel.text = data.magic.answer
            }
        } else {
            randomAnswersFromCoreData()
        }
        self.ballImage.stopAnimating()
    }
    
    private func randomAnswersFromCoreData() {
        if answers.isEmpty == true {
            answerLabel?.text = "you're lucky!"
        } else {
            answers.shuffle()
            let randomValueForArray = Int.random(in: 0...answers.count-1)
            let chooseAnswer = answers[randomValueForArray]
            answerLabel?.text = chooseAnswer.value(forKeyPath: "custAnswer") as? String
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
        
        let vc = TableViewSettingControllerTableViewController(nibName: "TableViewSettingControllerTableViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
