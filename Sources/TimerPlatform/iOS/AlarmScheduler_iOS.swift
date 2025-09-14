#if os(iOS)
import Foundation
@preconcurrency import UserNotifications

public enum AlarmActionID {
    public static let snooze5 = "ALARM_ACTION_SNOOZE_5"
    public static let openApp = "ALARM_ACTION_OPEN"
}
public enum AlarmCategoryID { public static let alarm = "ALARM_CATEGORY" }

@MainActor
public final class AlarmScheduler {
    public static let shared = AlarmScheduler()
    private init() {}

    public func configure() {
        let center = UNUserNotificationCenter.current()
        let snooze = UNNotificationAction(identifier: AlarmActionID.snooze5, title: "5分スヌーズ", options: [])
        let open   = UNNotificationAction(identifier: AlarmActionID.openApp, title: "開く", options: [.foreground])
        let cat = UNNotificationCategory(identifier: AlarmCategoryID.alarm,
                                         actions: [snooze, open],
                                         intentIdentifiers: [], options: [])
        center.setNotificationCategories([cat])
    }

    @discardableResult
    public func requestPermission() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    public func schedule(dateComponents: DateComponents,
                         repeats: Bool,
                         id: String,
                         title: String,
                         body: String) async throws {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = AlarmCategoryID.alarm

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await center.add(req)
    }

    public func scheduleSnooze(originalID: String, minutes: Int, title: String) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = "\(minutes)分後に再通知します"
        content.sound = .default
        content.categoryIdentifier = AlarmCategoryID.alarm

        let trig = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * 60), repeats: false)
        let req  = UNNotificationRequest(identifier: originalID + "_SNOOZE", content: content, trigger: trig)
        center.add(req)
    }

    public func cancel(ids: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
#endif
