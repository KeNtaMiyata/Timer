// Sources/TimerCore/Alarm.swift
import Foundation

public struct Alarm: Identifiable, Hashable, Codable {
    public var id: String
    public var time: Date
    public var title: String
    public var repeatsDaily: Bool
    public var weekdays: Set<Weekday>   // ← Weekday は TimerCore 内にあること

    public init(id: String = UUID().uuidString,
                time: Date,
                title: String,
                repeatsDaily: Bool = true,
                weekdays: Set<Weekday> = []) {
        self.id = id
        self.time = time
        self.title = title
        self.repeatsDaily = repeatsDaily
        self.weekdays = weekdays
    }
}
