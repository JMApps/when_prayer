import WidgetKit
import SwiftUI

// MARK: - Модель данных
struct PrayerEntry: TimelineEntry {
    let date: Date
    let prayers: [Prayer]
    let currentPrayerKey: String?

    struct Prayer {
        let nameKey: String   // "fajr", "sunrise", "dhuhr", ...
        let time: String      // "HH:mm" или "HH:mm:ss"
        let icon: String

        var localizedName: String {
            NSLocalizedString(nameKey, comment: "")
        }
    }
}

// MARK: – Цвета молитв
struct PrayerColors {
    static func color(for key: String) -> Color {
        switch key {
        case "fajr":     return .blue
        case "sunrise":  return .yellow
        case "dhuhr":    return .red
        case "asr":      return .orange
        case "maghrib":  return .brown
        case "isha":     return .black
        default:         return .indigo
        }
    }
}

// MARK: - Провайдер
struct PrayerProvider: TimelineProvider {
    private let userDefaults = UserDefaults(suiteName: "group.com.taqweem.whenPrayer")
    private let prayerKeys = ["fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"]

    func placeholder(in context: Context) -> PrayerEntry {
        defaultPrayerEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> Void) {
        completion(loadEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        let now = Date()
        let baseEntry = loadEntry(date: now)

        // ✅ Строим таймлайн на несколько переключений вперёд,
        // чтобы система гарантированно обновила UI в момент молитвы.
        var entries: [PrayerEntry] = [baseEntry]

        var cursorNow = now
        // 6 переключений вперёд (хватает на весь цикл)
        for _ in 0..<6 {
            let cursorEntry = loadEntry(date: cursorNow)

            guard
                let nextPrayer = PrayerUtils.getNextPrayer(from: cursorEntry, now: cursorNow),
                let nextSwitchDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: cursorEntry, now: cursorNow)
            else { break }

            // Чтобы не зациклиться в случае одинаковых дат
            if nextSwitchDate <= cursorNow { break }

            // Entry ровно в момент молитвы -> на нём nextPrayer уже станет “следующей”
            let switchEntry = loadEntry(date: nextSwitchDate)
            entries.append(switchEntry)

            // Сдвигаем “курсор” чуть после переключения
            cursorNow = nextSwitchDate.addingTimeInterval(1)
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }

    private func loadEntry(date: Date) -> PrayerEntry {
        let prayers = prayerKeys.map { key in
            PrayerEntry.Prayer(
                nameKey: key,
                time: userDefaults?.string(forKey: "prayer_\(key)") ?? "--:--",
                icon: iconForPrayer(key)
            )
        }

        let currentPrayerKey = userDefaults?.string(forKey: "current_prayer")?.lowercased()
        return PrayerEntry(date: date, prayers: prayers, currentPrayerKey: currentPrayerKey)
    }

    private func defaultPrayerEntry() -> PrayerEntry {
        let defaultPrayers = [
            PrayerEntry.Prayer(nameKey: "fajr", time: "04:12", icon: "sparkles"),
            PrayerEntry.Prayer(nameKey: "sunrise", time: "05:45", icon: "sunrise.fill"),
            PrayerEntry.Prayer(nameKey: "dhuhr", time: "12:30", icon: "sun.max.fill"),
            PrayerEntry.Prayer(nameKey: "asr", time: "15:45", icon: "sun.min.fill"),
            PrayerEntry.Prayer(nameKey: "maghrib", time: "18:38", icon: "sunset.fill"),
            PrayerEntry.Prayer(nameKey: "isha", time: "20:10", icon: "moon.stars.fill")
        ]
        return PrayerEntry(date: Date(), prayers: defaultPrayers, currentPrayerKey: nil)
    }

    private func iconForPrayer(_ key: String) -> String {
        switch key {
        case "fajr": return "sparkles"
        case "sunrise": return "sunrise.fill"
        case "dhuhr": return "sun.max.fill"
        case "asr": return "sun.min.fill"
        case "maghrib": return "sunset.fill"
        case "isha": return "moon.stars.fill"
        default: return "clock.fill"
        }
    }
}

// MARK: - Entry View
struct PrayerTimeWidgetEntryView: View {
    var entry: PrayerProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallPrayerView(entry: entry)
        case .systemMedium:
            MediumPrayerView(entry: entry)
        case .accessoryCircular:
            CirclePrayerView(entry: entry)
        default:
            EmptyView()
        }
    }
}

// MARK: - Medium
struct MediumPrayerView: View {
    let entry: PrayerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(entry.prayers.enumerated()), id: \.element.nameKey) { index, prayer in
                PrayerRow(prayer: prayer, entry: entry)
                if index < entry.prayers.count - 1 {
                    Divider().padding(.vertical, 4)
                }
            }
        }
        .padding(.vertical, 8)
        .widgetBackground(Color(.systemBackground))
    }
}

struct PrayerRow: View {
    let prayer: PrayerEntry.Prayer
    let entry: PrayerEntry

    var body: some View {
        let now = entry.date
        let nextPrayer = PrayerUtils.getNextPrayer(from: entry, now: now)
        let isNextPrayer = prayer.nameKey == nextPrayer?.nameKey
        let prayerColor = PrayerColors.color(for: prayer.nameKey)
        
        HStack(spacing: 0) {
            Image(systemName: prayer.icon)
                .foregroundColor(prayerColor.opacity(0.5))
                .frame(width: 16, height: 16)
                .font(.system(size: 14))

            Text(prayer.localizedName)
                .bold()
                .font(.system(.caption, design: .rounded))
                .foregroundColor(isNextPrayer ? .indigo : .primary)
                .padding(.horizontal, 8)

            Spacer()

            HStack(spacing: 8) {
                if isNextPrayer,
                   let targetDate = PrayerUtils.calculateTargetDate(for: prayer, entry: entry, now: now) {

                    Text("\(targetDate, style: .timer)")
                        .bold()
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.red.opacity(0.85))
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                }

                Text(PrayerUtils.formattedPrayerTimeSystemShort(prayer.time, now: now))
                    .bold()
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(isNextPrayer ? .indigo : .primary)
                    .monospacedDigit()
            }
        }
    }
}

// MARK: - Small
struct SmallPrayerView: View {
    let entry: PrayerEntry

    var body: some View {
        let now = entry.date

        GeometryReader { _ in
            ZStack {
                if let nextPrayer = PrayerUtils.getNextPrayer(from: entry, now: now),
                   let targetDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: entry, now: now) {

                    let ringColor = PrayerColors.color(for: nextPrayer.nameKey)

                    Circle()
                        .stroke(ringColor, style: StrokeStyle(lineWidth: 5))
                        .shadow(radius: 0.25)

                    VStack(spacing: 0) {
                        Text("\(targetDate, style: .timer)")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.red)
                            .monospacedDigit()
                            .multilineTextAlignment(.center)

                        Text(nextPrayer.localizedName)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .multilineTextAlignment(.center)

                        Text(PrayerUtils.formattedPrayerTimeSystemShort(nextPrayer.time, now: now))
                            .font(.system(.headline, design: .rounded))
                            .bold()
                            .foregroundColor(.secondary)
                            .monospacedDigit()
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    Text("--:--")
                        .foregroundColor(.gray)
                        .monospacedDigit()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(0)
        .widgetBackground(Color(.systemBackground))
    }
}

// MARK: - Lock Screen Circular
struct CirclePrayerView: View {
    let entry: PrayerEntry

    var body: some View {
        let now = entry.date

        GeometryReader { _ in
            ZStack {
                if let nextPrayer = PrayerUtils.getNextPrayer(from: entry, now: now),
                   let targetDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: entry, now: now) {

                    VStack(spacing: 2) {
                        Text("\(targetDate, style: .timer)")
                            .font(.system(.caption2, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .monospacedDigit()

                        Text(nextPrayer.localizedName)
                            .font(.system(.caption, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text(PrayerUtils.formattedPrayerTimeSystemShort(nextPrayer.time, now: now))
                            .font(.system(.caption, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    Text("--:--")
                        .foregroundColor(.gray)
                        .monospacedDigit()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .widgetBackground(Color(.systemBackground))
    }
}

// MARK: - Утилиты
struct PrayerUtils {

    // Парсим вход: "HH:mm" или "HH:mm:ss" -> Date на день, соответствующий now
    static func dateOnDay(from time: String, now: Date) -> Date? {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 || parts.count == 3 else { return nil }

        var c = Calendar.current.dateComponents([.year, .month, .day], from: now)
        c.hour = parts[0]
        c.minute = parts[1]
        c.second = (parts.count == 3) ? parts[2] : 0
        return Calendar.current.date(from: c)
    }

    // ✅ Время молитвы: системное (12/24)
    static func formattedPrayerTimeSystemShort(_ time: String, now: Date) -> String {
        guard let date = dateOnDay(from: time, now: now) else { return time }

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // ✅ Рассчитать дату наступления конкретной молитвы относительно now (а не Date())
    static func calculateTargetDate(for prayer: PrayerEntry.Prayer, entry: PrayerEntry, now: Date) -> Date? {
        guard let base = dateOnDay(from: prayer.time, now: now) else { return nil }

        // если fajr, и уже после иши этого дня -> fajr завтра
        if prayer.nameKey == "fajr",
           let isha = entry.prayers.first(where: { $0.nameKey == "isha" }),
           let ishaToday = dateOnDay(from: isha.time, now: now),
           now > ishaToday {

            return Calendar.current.date(byAdding: .day, value: 1, to: base)
        }

        return base
    }

    // ✅ Следующая молитва — ближайшая дата строго после now
    static func getNextPrayer(from entry: PrayerEntry, now: Date) -> PrayerEntry.Prayer? {

        let candidates: [(PrayerEntry.Prayer, Date)] = entry.prayers.compactMap { p in
            guard let d = calculateTargetDate(for: p, entry: entry, now: now) else { return nil }
            return (p, d)
        }

        if let future = candidates
            .filter({ $0.1 > now })
            .sorted(by: { $0.1 < $1.1 })
            .first {
            return future.0
        }

        // если всё прошло, берём ближайшую "завтра"
        let tomorrowCandidates: [(PrayerEntry.Prayer, Date)] = entry.prayers.compactMap { p in
            guard let today = dateOnDay(from: p.time, now: now),
                  let d = Calendar.current.date(byAdding: .day, value: 1, to: today) else { return nil }
            return (p, d)
        }

        return tomorrowCandidates.sorted(by: { $0.1 < $1.1 }).first?.0 ?? entry.prayers.first
    }
}

// MARK: - Конфигурация виджета
struct PrayerTimeWidget: Widget {
    let kind: String = "PrayerTimeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrayerProvider()) { entry in
            PrayerTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("prayer_times_display_name", comment: ""))
        .description(NSLocalizedString("prayer_times_display_description", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}

// MARK: - Background helper
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) { backgroundView }
        } else {
            return background(backgroundView)
        }
    }
}

// MARK: - Previews
struct PrayerTimeWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrayerTimeWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            PrayerTimeWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            PrayerTimeWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }

    static var sampleEntry: PrayerEntry {
        let prayers = [
            PrayerEntry.Prayer(nameKey: "fajr", time: "04:12", icon: "sparkles"),
            PrayerEntry.Prayer(nameKey: "sunrise", time: "05:45", icon: "sunrise.fill"),
            PrayerEntry.Prayer(nameKey: "dhuhr", time: "12:30", icon: "sun.max.fill"),
            PrayerEntry.Prayer(nameKey: "asr", time: "15:45", icon: "sun.min.fill"),
            PrayerEntry.Prayer(nameKey: "maghrib", time: "18:38", icon: "sunset.fill"),
            PrayerEntry.Prayer(nameKey: "isha", time: "20:10", icon: "moon.stars.fill")
        ]
        return PrayerEntry(date: Date(), prayers: prayers, currentPrayerKey: "asr")
    }
}
