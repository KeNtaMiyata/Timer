 
import Foundation

public enum NextFireCalculator {
    /// 指定アラームの「次回」発火日時を返す
    public static func nextFireDate(from alarm: Alarm, now: Date = Date(), calendar: Calendar = .current) -> Date? {
        if !alarm.weekdays.isEmpty {
            return nextWeeklyFireDate(weekdays: alarm.weekdays, time: alarm.time, now: now, calendar: calendar)
        } else if alarm.repeatsDaily {
            return nextDailyFireDate(time: alarm.time, now: now, calendar: calendar)
        } else {
            // 単発。過去なら翌日に寄せる
            if alarm.time > now { return alarm.time }
            return calendar.date(byAdding: .day, value: 1, to: alarm.time)
        }
    }

    /// 毎日くり返し（hour/minuteのみ見る）
    private static func nextDailyFireDate(time: Date, now: Date, calendar: Calendar) -> Date? {
        let hm = calendar.dateComponents([.hour, .minute], from: time)
        let today = calendar.date(bySettingHour: hm.hour ?? 0, minute: hm.minute ?? 0, second: 0, of: now)!
        if today > now { return today }
        return calendar.date(byAdding: .day, value: 1, to: today)
    }

    /// 曜日くり返し（最も近い未来の該当曜日のその時刻）
    private static func nextWeeklyFireDate(weekdays: Set<Weekday>, time: Date, now: Date, calendar: Calendar) -> Date? {
        guard !weekdays.isEmpty else { return nil }
        let hm = calendar.dateComponents([.hour, .minute], from: time)
        let todayWD = calendar.component(.weekday, from: now)

        for offset in 0..<14 { // 二週間以内に必ず見つかる
            let candidate = calendar.date(byAdding: .day, value: offset, to: now)!
            let wd = calendar.component(.weekday, from: candidate)
            if weekdays.contains(Weekday(rawValue: wd)!) {
                let atTime = calendar.date(bySettingHour: hm.hour ?? 0, minute: hm.minute ?? 0, second: 0, of: candidate)!
                if atTime > now { return atTime }
            }
        }
        return nil
    }
}
