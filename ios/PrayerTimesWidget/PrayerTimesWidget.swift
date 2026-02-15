import WidgetKit
import SwiftUI

// MARK: - Модель данных
struct PrayerEntry: TimelineEntry {
    let date: Date
    let prayers: [Prayer]
    let currentPrayerKey: String?

    struct Prayer {
        let nameKey: String   // ключ локализации: "fajr"
        let time: String      // "HH:mm" или "HH:mm:ss"
        let icon: String

        var localizedName: String {
            // ВАЖНО: Localizable.strings должен быть включен в Target Membership PrayerTimesWidgetExtension
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
        completion(defaultPrayerEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        let now = Date()

        let prayers = prayerKeys.map { key in
            PrayerEntry.Prayer(
                nameKey: key,
                time: userDefaults?.string(forKey: "prayer_\(key)") ?? "--:--",
                icon: iconForPrayer(key)
            )
        }

        let currentPrayerKey = userDefaults?.string(forKey: "current_prayer")?.lowercased()

        var entries: [PrayerEntry] = []
        let initialEntry = PrayerEntry(date: now, prayers: prayers, currentPrayerKey: currentPrayerKey)
        entries.append(initialEntry)

        // Вторая точка таймлайна: на наступление следующей молитвы (если вычислилась)
        if let nextPrayer = PrayerUtils.getNextPrayer(from: initialEntry),
           let targetDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: initialEntry),
           targetDate > now {

            // На момент наступления следующей молитвы
            // (можешь захотеть обновить currentPrayerKey — но обычно он приходит из app group)
            let nextEntry = PrayerEntry(date: targetDate, prayers: prayers, currentPrayerKey: currentPrayerKey)
            entries.append(nextEntry)
        }

        completion(Timeline(entries: entries, policy: .atEnd))
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

// MARK: - Виджет
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

// MARK: - Средний виджет
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

// MARK: - Ряд молитвы (Medium)
struct PrayerRow: View {
    let prayer: PrayerEntry.Prayer
    let entry: PrayerEntry

    var body: some View {
        let nextPrayer = PrayerUtils.getNextPrayer(from: entry)
        let isNextPrayer = prayer.nameKey == nextPrayer?.nameKey

        HStack(spacing: 0) {
            Image(systemName: prayer.icon)
                .foregroundColor(isNextPrayer ? .indigo : .secondary)
                .frame(width: 16, height: 16)
                .font(.system(size: 14))

            Text(prayer.localizedName)
                .bold()
                .font(.system(.caption, design: .rounded))
                .foregroundColor(isNextPrayer ? .indigo : .primary)
                .padding(.horizontal, 8)

            Spacer()

            HStack(spacing: 6) {
                // ✅ Остаток: всегда -HH:mm (24h)
                if isNextPrayer,
                   let targetDate = PrayerUtils.calculateTargetDate(for: prayer, entry: entry) {

                    TimelineView(.periodic(from: Date(), by: 60)) { context in
                        Text(verbatim: "-\(PrayerUtils.remainingHHmm24(to: targetDate, now: context.date))")
                            .bold()
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.red.opacity(0.85))
                            .multilineTextAlignment(.trailing)
                            .monospacedDigit()
                    }
                }

                // ✅ Время молитвы: системное (12/24 + AM/PM) — уважает настройку iPhone
                Text(PrayerUtils.formattedPrayerTimeSystemHHmm(prayer.time))
                    .bold()
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(isNextPrayer ? .indigo : .primary)
                    .monospacedDigit()
            }
        }
    }
}

// MARK: - Маленький виджет
struct SmallPrayerView: View {
    let entry: PrayerEntry

    var body: some View {
        GeometryReader { _ in
            ZStack {
                if let nextPrayer = PrayerUtils.getNextPrayer(from: entry),
                   let targetDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: entry) {

                    let ringColor = PrayerColors.color(for: nextPrayer.nameKey)

                    Circle()
                        .stroke(ringColor, style: StrokeStyle(lineWidth: 10))
                        .shadow(radius: 0.25)

                    VStack(spacing: 4) {

                        // Остаток времени
                        TimelineView(.periodic(from: Date(), by: 60)) { context in
                            Text(verbatim: "-\(PrayerUtils.remainingHHmm24(to: targetDate, now: context.date))")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.red)
                                .monospacedDigit()
                                .multilineTextAlignment(.center)
                        }

                        // Название молитвы
                        Text(nextPrayer.localizedName)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .multilineTextAlignment(.center)

                        // Время молитвы (12/24 по системе)
                        Text(PrayerUtils.formattedPrayerTimeSystemHHmm(nextPrayer.time))
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


// MARK: - Виджет экрана блокировки (круглый)
struct CirclePrayerView: View {
    let entry: PrayerEntry

    var body: some View {
        GeometryReader { _ in
            ZStack {
                if let nextPrayer = PrayerUtils.getNextPrayer(from: entry),
                   let targetDate = PrayerUtils.calculateTargetDate(for: nextPrayer, entry: entry) {

                    VStack(spacing: 2) {
                        // ✅ Остаток: -HH:mm (24h)
                        TimelineView(.periodic(from: Date(), by: 60)) { context in
                            Text(verbatim: "-\(PrayerUtils.remainingHHmm24(to: targetDate, now: context.date))")
                                .font(.system(.caption2, design: .rounded))
                                .bold()
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                        }

                        Text(nextPrayer.localizedName)
                            .font(.system(.caption, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text(PrayerUtils.formattedPrayerTimeSystemHHmm(nextPrayer.time))
                            .font(.system(.caption, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    Text("--:--").foregroundColor(.gray).monospacedDigit()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .widgetBackground(Color(.systemBackground))
    }
}

// MARK: - Утилиты
struct PrayerUtils {

    // Парсим вход: "HH:mm" или "HH:mm:ss" -> Date на сегодня
    static func dateToday(from time: String, now: Date = Date()) -> Date? {
        // допускаем "HH:mm" или "HH:mm:ss"
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 || parts.count == 3 else { return nil }

        var c = Calendar.current.dateComponents([.year, .month, .day], from: now)
        c.hour = parts[0]
        c.minute = parts[1]
        c.second = (parts.count == 3) ? parts[2] : 0
        return Calendar.current.date(from: c)
    }

    // ✅ Время молитвы: системное (12/24 + AM/PM) — уважает настройку iPhone/Watch
    // ВАЖНО: используем timeStyle = .short, это надежнее чем template "jm" внутри Widget Extension.
    static func formattedPrayerTimeSystemHHmm(_ time: String) -> String {
        guard let date = dateToday(from: time) else { return time }

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .none
        formatter.timeStyle = .short // <-- учитывает 12/24 и AM/PM

        return formatter.string(from: date)
    }

    // fajr переносим на завтра, если уже после иши
    static func calculateTargetDate(for prayer: PrayerEntry.Prayer, entry: PrayerEntry) -> Date? {
        guard let base = dateToday(from: prayer.time) else { return nil }

        if prayer.nameKey == "fajr",
           let isha = entry.prayers.first(where: { $0.nameKey == "isha" }),
           let ishaToday = dateToday(from: isha.time),
           Date() > ishaToday {

            return Calendar.current.date(byAdding: .day, value: 1, to: base)
        }

        return base
    }

    // ✅ Остаток: всегда "HH:mm" (24h), без AM/PM
    static func remainingHHmm24(to targetDate: Date, now: Date = Date()) -> String {
        let total = max(0, Int(targetDate.timeIntervalSince(now)))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    // ✅ Следующая молитва по Date
    static func getNextPrayer(from entry: PrayerEntry) -> PrayerEntry.Prayer? {
        let now = Date()

        let candidates: [(PrayerEntry.Prayer, Date)] = entry.prayers.compactMap { p in
            guard let d = calculateTargetDate(for: p, entry: entry) else { return nil }
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
            guard let today = dateToday(from: p.time),
                  let d = Calendar.current.date(byAdding: .day, value: 1, to: today) else { return nil }
            return (p, d)
        }

        return tomorrowCandidates.sorted(by: { $0.1 < $1.1 }).first?.0 ?? entry.prayers.first
    }
}

// MARK: - Конфигурация
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

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) { backgroundView }
        } else {
            return background(backgroundView)
        }
    }
}

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
