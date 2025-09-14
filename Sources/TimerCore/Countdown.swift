// Sources/TimerCore/Countdown.swift
import Foundation

public struct Countdown {
    public init() {}

    /// 秒を "MM:SS" でゼロ埋め表示
    public func format(seconds: Int) -> String {
        let s = max(0, seconds)
        let m = s / 60
        let sec = s % 60
        return String(format: "%02d:%02d", m, sec)
    }
}
