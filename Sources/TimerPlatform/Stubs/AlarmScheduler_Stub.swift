#if !os(iOS)
import Foundation

public enum AlarmActionID {
    public static let snooze5 = "ALARM_ACTION_SNOOZE_5"
    public static let openApp = "ALARM_ACTION_OPEN"
}
public enum AlarmCategoryID {
    public static let alarm = "ALARM_CATEGORY"
}

@MainActor
public final class AlarmScheduler {
    public static let shared = AlarmScheduler()
    private init() {}

    public func configure() {}
    @discardableResult
    public func requestPermission() async throws -> Bool { true }
    public func schedule(dateComponents: DateComponents, repeats: Bool, id: String, title: String, body: String) async throws {}
    public func scheduleSnooze(originalID: String, minutes: Int, title: String) {}
    public func cancel(ids: [String]) {}
}
#endif
