import UIKit

class CalendarViewController: UIViewController {
    private let calendarView = UIDatePicker()
    private let infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Calendar"
        setupCalendar()
        setupInfoLabel()
    }
    
    private func setupCalendar() {
        calendarView.datePickerMode = .date
        calendarView.preferredDatePickerStyle = .inline
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupInfoLabel() {
        infoLabel.font = .systemFont(ofSize: 18, weight: .medium)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        updateInfoLabel(for: Date())
    }
    
    @objc private func dateChanged() {
        updateInfoLabel(for: calendarView.date)
    }
    
    private func updateInfoLabel(for date: Date) {
        let calendar = Calendar.current
        let lastCheckIn = UserDefaults.standard.lastCheckIn
        let isWorn = lastCheckIn != nil && calendar.isDate(lastCheckIn!, inSameDayAs: date)
        if isWorn {
            infoLabel.text = "✅ Retainer worn on this day!"
        } else {
            infoLabel.text = "No retainer record for this day."
        }
    }
}
