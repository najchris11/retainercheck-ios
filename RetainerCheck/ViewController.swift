//
//  ViewController.swift
//  RetainerCheck
//
//  Created by Christian Coulibaly on 8/5/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    // UI Elements
    private let appNameLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let streakLabel = UILabel()
    private let retainerButton = UIButton(type: .system)
    private let breakButton = UIButton(type: .system)
    
    // Logic variables
    private var isWearingRetainer: Bool {
        get { UserDefaults.standard.isWearingRetainer }
        set {
            UserDefaults.standard.isWearingRetainer = newValue
            updateUI()
            if newValue {
                checkAndUpdateStreak()
            }
        }
    }
    
    private var currentStreak: Int {
        get { UserDefaults.standard.currentStreak }
        set {
            UserDefaults.standard.currentStreak = newValue
            if newValue > UserDefaults.standard.longestStreak {
                UserDefaults.standard.longestStreak = newValue
            }
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    private func setupUI() {
        configureAppNameLabel()
        configureWelcomeLabel()
        configureStreakLabel()
        configureRetainerButton()
        configureBreakButton()
        setupConstraints()
        updateUI()
    }
    
    private func configureAppNameLabel() {
        appNameLabel.text = "RetainerCheck"
        appNameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appNameLabel)
    }
    
    private func configureWelcomeLabel() {
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = .systemFont(ofSize: 20)
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
    }
    
    private func configureStreakLabel() {
        streakLabel.font = .systemFont(ofSize: 18)
        streakLabel.textAlignment = .center
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(streakLabel)
    }
    
    private func configureRetainerButton() {
        retainerButton.translatesAutoresizingMaskIntoConstraints = false
        retainerButton.addTarget(self, action: #selector(toggleRetainer), for: .touchUpInside)
        retainerButton.layer.cornerRadius = 75
        retainerButton.clipsToBounds = true
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .systemGreen
            config.cornerStyle = .capsule
            config.image = UIImage(systemName: "mouth.fill")
            config.imagePlacement = .top
            config.imagePadding = 8
            config.title = "Retainer\nON"
            config.titleAlignment = .center
            config.attributedTitle = AttributedString("Retainer\nON", attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 18)]))
            retainerButton.configuration = config
            retainerButton.tintColor = .white
        } else {
            // Fallback for iOS < 15: manually adjust image and title
            retainerButton.setImage(UIImage(systemName: "mouth.fill"), for: .normal)
            retainerButton.setTitle("Retainer\nON", for: .normal)
            retainerButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            retainerButton.tintColor = .white
            retainerButton.contentVerticalAlignment = .center
            retainerButton.contentHorizontalAlignment = .center
            retainerButton.titleEdgeInsets = UIEdgeInsets(top: 70, left: -40, bottom: 0, right: 0)
            retainerButton.imageEdgeInsets = UIEdgeInsets(top: -20, left: 25, bottom: 20, right: -25)
        }
        // ...existing code for gradient/shadow if any...
        view.addSubview(retainerButton)
    }
    
    private func configureBreakButton() {
        breakButton.translatesAutoresizingMaskIntoConstraints = false
        breakButton.addTarget(self, action: #selector(takeBreak), for: .touchUpInside)
        breakButton.layer.cornerRadius = 75
        breakButton.clipsToBounds = true
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .systemOrange
            config.cornerStyle = .capsule
            config.image = UIImage(systemName: "pause.circle.fill")
            config.imagePlacement = .top
            config.imagePadding = 8
            config.title = "Take a\nBreak"
            config.titleAlignment = .center
            config.attributedTitle = AttributedString("Take a\nBreak", attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 18)]))
            breakButton.configuration = config
            breakButton.tintColor = .white
        } else {
            breakButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            breakButton.setTitle("Take a\nBreak", for: .normal)
            breakButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            breakButton.tintColor = .white
            breakButton.contentVerticalAlignment = .center
            breakButton.contentHorizontalAlignment = .center
            breakButton.titleEdgeInsets = UIEdgeInsets(top: 70, left: -40, bottom: 0, right: 0)
            breakButton.imageEdgeInsets = UIEdgeInsets(top: -20, left: 25, bottom: 20, right: -25)
        }
        // ...existing code for gradient/shadow if any...
        view.addSubview(breakButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 16),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            streakLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24),
            streakLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            retainerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            retainerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            retainerButton.widthAnchor.constraint(equalToConstant: 150),
            retainerButton.heightAnchor.constraint(equalToConstant: 150),
            
            breakButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            breakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            breakButton.widthAnchor.constraint(equalToConstant: 150),
            breakButton.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func updateUI() {
        streakLabel.text = "Current Streak: \(currentStreak) days"
        
        if isWearingRetainer {
            retainerButton.backgroundColor = .systemGreen
            retainerButton.setTitle("Retainer\nON", for: .normal)
        } else {
            retainerButton.backgroundColor = .systemRed
            retainerButton.setTitle("Retainer\nOFF", for: .normal)
        }
        
        breakButton.isEnabled = isWearingRetainer
        breakButton.alpha = isWearingRetainer ? 1.0 : 0.5
    }
    
    @objc private func toggleRetainer() {
        isWearingRetainer.toggle()
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc private func takeBreak() {
        let alert = UIAlertController(
            title: "Take a Break",
            message: "How long would you like to take a break?",
            preferredStyle: .actionSheet
        )
        
        let durations = [15, 30, 45, 60]
        
        for duration in durations {
            alert.addAction(UIAlertAction(title: "\(duration) minutes", style: .default) { [weak self] _ in
                self?.startBreak(duration: duration)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func startBreak(duration: Int) {
        let endTime = Date().addingTimeInterval(TimeInterval(duration * 60))
        UserDefaults.standard.breakEndTime = endTime
        
        // Schedule local notification
        let content = UNMutableNotificationContent()
        content.title = "Break Time Over!"
        content.body = "Time to put your retainer back in"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(duration * 60), repeats: false)
        let request = UNNotificationRequest(identifier: "breakOver", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        isWearingRetainer = false
    }
    
    private func checkAndUpdateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let lastCheckIn = UserDefaults.standard.lastCheckIn {
            let lastCheckInDay = calendar.startOfDay(for: lastCheckIn)
            let daysBetween = calendar.dateComponents([.day], from: lastCheckInDay, to: today).day ?? 0
            if daysBetween == 0 {
                // Already checked in today, do nothing
                return
            } else if daysBetween == 1 {
                // Checked in yesterday, increment streak
                currentStreak += 1
            } else {
                // Missed a day, reset streak
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        UserDefaults.standard.lastCheckIn = today
    }
}
