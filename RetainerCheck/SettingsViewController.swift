import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    private let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Notifications"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reminderTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Break Duration"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let durations = ["15 minutes", "30 minutes", "45 minutes", "1 hour"]
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter your name"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Statistics", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchChanged), for: .valueChanged)
        nameField.text = UserDefaults.standard.string(forKey: "userName")
        nameField.addTarget(self, action: #selector(nameChanged), for: .editingDidEnd)
        resetButton.addTarget(self, action: #selector(resetStats), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        view.addSubview(settingsStack)
        NSLayoutConstraint.activate([
            settingsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            settingsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        // Name section
        let nameSection = makeSettingsCard(icon: "person.fill", title: "Name", content: nameField)
        // Notifications section
        let notifRow = makeSettingsRow(icon: "bell.fill", label: notificationLabel, control: notificationSwitch)
        let notifSection = makeSettingsCard(icon: "bell.fill", title: "Notifications", content: notifRow)
        // Break duration section
        let breakSection = makeSettingsCard(icon: "timer", title: "Default Break Duration", content: durationPicker)
        // Reset section
        let resetSection = makeSettingsCard(icon: "arrow.counterclockwise", title: "Reset", content: resetButton)
        settingsStack.addArrangedSubview(nameSection)
        settingsStack.addArrangedSubview(notifSection)
        settingsStack.addArrangedSubview(breakSection)
        settingsStack.addArrangedSubview(resetSection)
    }
    
    private func makeSettingsCard(icon: String, title: String, content: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.07
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let hStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        let vStack = UIStackView(arrangedSubviews: [hStack, content])
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            vStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            iconView.widthAnchor.constraint(equalToConstant: 22)
        ])
        return card
    }
    
    private func makeSettingsRow(icon: String, label: UILabel, control: UIView) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let hStack = UIStackView(arrangedSubviews: [iconView, label, control])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 22),
            iconView.widthAnchor.constraint(equalToConstant: 22)
        ])
        return hStack
    }
    
    @objc private func notificationSwitchChanged() {
        if notificationSwitch.isOn {
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.notificationSwitch.isOn = granted
            }
        }
    }
    
    @objc private func nameChanged() {
        UserDefaults.standard.set(nameField.text, forKey: "userName")
    }
    
    @objc private func resetStats() {
        let alert = UIAlertController(title: "Reset Statistics", message: "Are you sure you want to reset your streak and stats?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.currentStreak = 0
            UserDefaults.standard.longestStreak = 0
            UserDefaults.standard.lastCheckIn = nil
            UserDefaults.standard.isWearingRetainer = false
        })
        present(alert, animated: true)
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durations[row]
    }
}
