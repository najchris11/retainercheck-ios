import UIKit

class StatsViewController: UIViewController {
    
    private let streakHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Streak History"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let longestStreakLabel: UILabel = {
        let label = UILabel()
        label.text = "Longest Streak: 0 days"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentStreakLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Streak: 0 days"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastCheckInLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Check-in: Never"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshStats()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Statistics"
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        stack.addArrangedSubview(makeStatCard(icon: "flame.fill", title: "Current Streak", label: currentStreakLabel))
        stack.addArrangedSubview(makeStatCard(icon: "crown.fill", title: "Longest Streak", label: longestStreakLabel))
        stack.addArrangedSubview(makeStatCard(icon: "calendar", title: "Last Check-in", label: lastCheckInLabel))
    }
    
    private func makeStatCard(icon: String, title: String, label: UILabel) -> UIView {
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
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        let vStack = UIStackView(arrangedSubviews: [iconView, titleLabel, label])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            vStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32)
        ])
        return card
    }
    
    private func refreshStats() {
        let currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        let longestStreak = UserDefaults.standard.integer(forKey: "longestStreak")
        
        updateStats(currentStreak: currentStreak, longestStreak: longestStreak)
        
        if let lastCheckIn = UserDefaults.standard.object(forKey: "lastCheckIn") as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            lastCheckInLabel.text = "Last Check-in: \(formatter.string(from: lastCheckIn))"
        } else {
            lastCheckInLabel.text = "Last Check-in: Never"
        }
    }
    
    func updateStats(currentStreak: Int, longestStreak: Int) {
        currentStreakLabel.text = "Current Streak: \(currentStreak) days"
        longestStreakLabel.text = "Longest Streak: \(longestStreak) days"
    }
}
