#if canImport(SwiftUI)
import SwiftUI
import TimerCore

public struct AlarmEditorView: View {
    @Environment(\.dismiss) private var dismiss

    // 入力状態
    @State private var time: Date = Calendar.current.date(
        bySettingHour: 7, minute: 0, second: 0, of: Date()
    )!
    @State private var title: String = "朝のアラーム"
    @State private var repeatsDaily: Bool = true
    @State private var selectedWeekdays: Set<Weekday> = []

    // 保存時コールバック（呼び出し側が受け取る）
    public let onSave: (Alarm) -> Void

    public init(onSave: @escaping (Alarm) -> Void) {
        self.onSave = onSave
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("時刻",
                               selection: $time,
                               displayedComponents: [.hourAndMinute, .date])
                    TextField("タイトル", text: $title)
                        .textInputAutocapitalization(.never)
                }

                Section("<くり返し>") {
                    Toggle("毎日くり返す（曜日指定なし）", isOn: $repeatsDaily)
                        .onChange(of: repeatsDaily) { newValue in
                            if newValue {
                                // 毎日繰り返しにしたら曜日指定はクリア
                                selectedWeekdays.removeAll()
                            }
                        }

                    WeekdayPicker(selected: $selectedWeekdays)
                        .disabled(repeatsDaily)
                        .opacity(repeatsDaily ? 0.4 : 1.0)
                }
            }
            .navigationTitle("アラーム追加")
            // ▼ ここがポイント：ToolbarContent を明示
            .toolbar { editorToolbar }
        }
    }

    // MARK: - Toolbar（曖昧さをなくすために ToolbarContent を明示）

    @ToolbarContentBuilder
    private var editorToolbar: some ToolbarContent {
        // iOS16+ は .cancellationAction / .confirmationAction が安定
        ToolbarItem(placement: .cancellationAction) {
            Button("キャンセル") { dismiss() }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button("保存") {
                let alarm = Alarm(
                    time: time,
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? "アラーム" : title,
                    // 曜日未指定なら「毎日」
                    repeatsDaily: repeatsDaily || selectedWeekdays.isEmpty,
                    weekdays: selectedWeekdays
                )
                onSave(alarm)
                dismiss()
            }
            // タイトル未入力なら保存を無効化したい場合は以下をアンコメント
            //.disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true)
        }
    }
}

// MARK: - WeekdayPicker
private struct WeekdayPicker: View {
    @Binding var selected: Set<Weekday>

    var body: some View {
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
