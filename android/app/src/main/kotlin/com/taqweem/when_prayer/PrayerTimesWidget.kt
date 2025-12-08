package com.taqweem.when_prayer

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Locale

class PrayerTimesWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.prayer_times_widget).apply {

                val nullTime = context.getString(R.string.nullTime)

                val fajrRaw = widgetData.getString("prayer_fajr", nullTime)
                val sunriseRaw = widgetData.getString("prayer_sunrise", nullTime)
                val dhuhrRaw = widgetData.getString("prayer_dhuhr", nullTime)
                val asrRaw = widgetData.getString("prayer_asr", nullTime)
                val maghribRaw = widgetData.getString("prayer_maghrib", nullTime)
                val ishaRaw = widgetData.getString("prayer_isha", nullTime)

                val fajr = formatPrayerTime(fajrRaw, context)
                val sunrise = formatPrayerTime(sunriseRaw, context)
                val dhuhr = formatPrayerTime(dhuhrRaw, context)
                val asr = formatPrayerTime(asrRaw, context)
                val maghrib = formatPrayerTime(maghribRaw, context)
                val isha = formatPrayerTime(ishaRaw, context)

                setTextViewText(R.id.fajr_time, fajr)
                setTextViewText(R.id.sunrise_time, sunrise)
                setTextViewText(R.id.dhuhr_time, dhuhr)
                setTextViewText(R.id.asr_time, asr)
                setTextViewText(R.id.maghrib_time, maghrib)
                setTextViewText(R.id.isha_time, isha)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun formatPrayerTime(raw: String?, context: Context): String {
        if (raw.isNullOrBlank()) return context.getString(R.string.nullTime)

        return try {
            val is24 = android.text.format.DateFormat.is24HourFormat(context)

            val inFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
            val date = inFormat.parse(raw)

            val outPattern = if (is24) "HH:mm" else "hh:mm a"
            val outFormat = SimpleDateFormat(outPattern, Locale.getDefault())

            outFormat.format(date!!)
        } catch (_: Exception) {
            raw
        }
    }
}
