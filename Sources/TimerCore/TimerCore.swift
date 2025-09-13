import Foundation


public struct TimerCore {
    public static func greeting() -> String {
        return "Hello from TimerCore"
    }
}

public struct Countdown {
    public init() {}

    public func format(seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
