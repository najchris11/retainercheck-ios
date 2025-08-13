import Foundation

extension UserDefaults {
    private enum Keys {
        static let currentStreak = "currentStreak"
        static let longestStreak = "longestStreak"
        static let lastCheckIn = "lastCheckIn"
        static let isWearingRetainer = "isWearingRetainer"
        static let breakEndTime = "breakEndTime"
    }
    
    var currentStreak: Int {
        get { integer(forKey: Keys.currentStreak) }
        set { set(newValue, forKey: Keys.currentStreak) }
    }
    
    var longestStreak: Int {
        get { integer(forKey: Keys.longestStreak) }
        set { set(newValue, forKey: Keys.longestStreak) }
    }
    
    var lastCheckIn: Date? {
        get { object(forKey: Keys.lastCheckIn) as? Date }
        set { set(newValue, forKey: Keys.lastCheckIn) }
    }
    
    var isWearingRetainer: Bool {
        get { bool(forKey: Keys.isWearingRetainer) }
        set { set(newValue, forKey: Keys.isWearingRetainer) }
    }
    
    var breakEndTime: Date? {
        get { object(forKey: Keys.breakEndTime) as? Date }
        set { set(newValue, forKey: Keys.breakEndTime) }
    }
}