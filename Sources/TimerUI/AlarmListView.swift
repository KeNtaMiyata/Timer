 
#if canImport(SwiftUI)
import SwiftUI
import TimerCore
import TimerPlatform

public struct AlarmListView: View {
    @State private var alarms: [Alarm] = []
    @State private var showEditor = false

    public init() {}

    public var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Theme.sunriseTop, Theme.sunriseBottom]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("おはようアラーム")
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .foregroundStyle(.black.opacity(0.85))
                    Spacer()
                    Button { showEditor = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Theme.accent)
                    }
                }
                .padding()

                List {
                    ForEach(alarms) { alarm in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(alarm.title).font(.headline)
                                Text(alarm.time, style: .time)
                                    .font(.title2.weight(.semibold))
                                HStack(spacing: 6) {
                                    if !alarm.weekdays.isEmpty {
                                        Text(alarm.weekdays.sorted().map { $0.shortJP }.joined())
                                            .font(.caption)
                                            .padding(.horizontal, 8).padding(.vertical, 4)
                                            .background(Theme.accent.opacity(0.15))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } else if alarm.repeatsDaily {
                                        Text("毎日").font(.caption)
                                    } else {
                                        Text("単発").font(.caption)
                                    }
                                }
                            }
                            Spacer()
                            Image(systemName: "bell.fill").foregroundStyle(Theme.accent)
                        }
                        .listRowBackground(Theme.cardBG)
                    }
                    .onDelete(perform: delete)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .sheet(isPresented: $showEditor) {
            AlarmEditorView { alarm in
                Task { await add(alarm) }
            }
        }
        .task {
            AlarmScheduler.shared.configure()
            _ = try? await AlarmScheduler.shared.requestPermission()
        }
        .tint(Theme.accent)
    }

    private func add(_ alarm: Alarm) async {
        alarms.append(alarm)
        await schedule(alarm)
    }

    private func delete(at offsets: IndexSet) {
        var ids: [String] = []
        for i in offsets { ids.append(alarms[i].id) }
        AlarmScheduler.shared.cancel(ids: ids)
        alarms.remove(atOffsets: offsets)
    }

    private func schedule(_ alarm: Alarm) async {
        let cal = Calendar.current
        let hm = cal.dateComponents([.hour, .minute], from: alarm.time)

        if !alarm.weekdays.isEmpty {
            for wd in alarm.weekdays {
                var comps = DateComponents()
                comps.weekday = wd.rawValue
                comps.hour = hm.hour
                comps.minute = hm.minute
                try? await AlarmScheduler.shared.schedule(dateComponents: comps, repeats: true,
                                                          id: "\(alarm.id)_\(wd.rawValue)",
                                                          title: alarm.title,
                                                          body: "アラームです")
            }
        } else if alarm.repeatsDaily {
            var comps = DateComponents()
            comps.hour = hm.hour
            comps.minute = hm.minute
            try? await AlarmScheduler.shared.schedule(dateComponents: comps, repeats: true,
                                                      id: alarm.id, title: alarm.title, body: "毎日この時刻に通知します")
        } else {
            // 単発：過去指定は翌日に
            let next = NextFireCalculator.nextFireDate(from: alarm) ?? alarm.time
            let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: next)
            try? await AlarmScheduler.shared.schedule(dateComponents: comps, repeats: false,
                                                      id: alarm.id, title: alarm.title, body: "単発のアラームです")
        }
    }
}
#endif
