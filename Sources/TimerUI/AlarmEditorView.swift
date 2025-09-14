#if canImport(SwiftUI)
import SwiftUI
import TimerCore

public struct AlarmEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var time: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var title: String = "朝のアラーム"
    @State private var repeatsDaily: Bool = true
    @State private var selectedWeekdays: Set<Weekday> = []

    public let onSave: (Alarm) -> Void

    public init(onSave: @escaping (Alarm) -> Void) {
        self.onSave = onSave
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("時刻", selection: $time, displayedComponents: [.hourAndMinute, .date])
                    TextField("タイトル", text: $title)
                }
                Section("くり返し") {
                    Toggle("毎日くり返す（曜日指定なし）", isOn: $repeatsDaily)
                        .onChange(of: repeatsDaily) { _, newValue in
                            if newValue { selectedWeekdays.removeAll() }
                        }
                    WeekdayPicker(selected: $selectedWeekdays)   // ← Binding<Set<Weekday>>
                        .disabled(repeatsDaily)
                }
            }
            // AlarmEditorView.swift（TimerUI）
            .navigationTitle("アラーム追加")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let alarm = Alarm(
                            time: time,
                            title: title.isEmpty ? "アラーム" : title,
                            repeatsDaily: repeatsDaily && selectedWeekdays.isEmpty,
                            weekdays: selectedWeekdays
                        )
                        onSave(alarm)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
            }


        }
    }
}

private struct WeekdayPicker: View {
    @Binding var selected: Set<Weekday>

    var body: some View {
        // Set は ForEach に直接渡さず、配列にして id: \.self を付ける
        let days = Weekday.allCases.sorted()
        let columns = [GridItem(.adaptive(minimum: 44))]

        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(days, id: \.self) { wd in
                let isOn = selected.contains(wd)
                Text(wd.shortJP)
                    .font(.headline)
                    .frame(width: 44, height: 44)
                    .background(isOn ? Color.orange.opacity(0.85) : Color.secondary.opacity(0.15))
                    .foregroundStyle(isOn ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        if isOn { selected.remove(wd) } else { selected.insert(wd) }
                    }
                    .animation(.spring(duration: 0.2), value: isOn)
            }
        }
        .padding(.vertical, 4)
    }
}
#endif
