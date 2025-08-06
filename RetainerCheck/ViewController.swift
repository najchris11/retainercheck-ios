//
//  ViewController.swift
//  RetainerCheck
//
//  Created by Christian Coulibaly on 8/5/25.
//

import UIKit

class ViewController: UIViewController {
    // UI Elements
    let appNameLabel = UILabel()
    let welcomeLabel = UILabel()
    let streakLabel = UILabel()
    let retainerButton = UIButton(type: .system)
    let breakButton = UIButton(type: .system)
    
    // Logic variables
    var isWearingRetainer = false {
        didSet {
            updateRetainerButton()
            streakLabel.text = "Streak: \(isWearingRetainer ? streakCount : 0)"
        }
    }
    var streakCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func setupUI() {
        // App Name
        appNameLabel.text = "RetainerCheck"
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appNameLabel)
        
        // Welcome
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 20)
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        // Streak
        streakLabel.text = "Streak: 0"
        streakLabel.font = UIFont.systemFont(ofSize: 18)
        streakLabel.textAlignment = .center
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streakLabel)
        
        // Retainer Button
        retainerButton.translatesAutoresizingMaskIntoConstraints = false
        retainerButton.addTarget(self, action: #selector(toggleRetainer), for: .touchUpInside)
        retainerButton.layer.cornerRadius = 60
        retainerButton.clipsToBounds = true
        retainerButton.backgroundColor = .systemBlue
        retainerButton.setTitleColor(.white, for: .normal)
        retainerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(retainerButton)
        updateRetainerButton()
        
        // Break Button
        breakButton.translatesAutoresizingMaskIntoConstraints = false
        breakButton.addTarget(self, action: #selector(takeBreak), for: .touchUpInside)
        breakButton.layer.cornerRadius = 60
        breakButton.clipsToBounds = true
        breakButton.backgroundColor = .systemRed
        breakButton.setTitle("Take a Break", for: .normal)
        breakButton.setTitleColor(.white, for: .normal)
        breakButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(breakButton)
        
        // Layout
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 16),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            streakLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24),
            streakLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            retainerButton.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 48),
            retainerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            retainerButton.widthAnchor.constraint(equalToConstant: 120),
            retainerButton.heightAnchor.constraint(equalToConstant: 120),
            
            breakButton.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 48),
            breakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            breakButton.widthAnchor.constraint(equalToConstant: 120),
            breakButton.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func updateRetainerButton() {
        let title = isWearingRetainer ? "Retainer ON" : "Retainer OFF"
        retainerButton.setTitle(title, for: .normal)
        retainerButton.backgroundColor = isWearingRetainer ? .systemGreen : .systemBlue
    }
    
    @objc func toggleRetainer() {
        isWearingRetainer.toggle()
        if isWearingRetainer {
            streakCount += 1
        } else {
            streakCount = 0
        }
        streakLabel.text = "Streak: \(streakCount)"
    }
    
    @objc func takeBreak() {
        let alert = UIAlertController(title: "Break Started", message: "Don't forget to put your retainer back in after your break!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
