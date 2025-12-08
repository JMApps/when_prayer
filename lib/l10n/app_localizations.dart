import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ka'),
    Locale('kk'),
    Locale('ky'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Muslim\'s shelf'**
  String get appName;

  /// No description provided for @shelf.
  ///
  /// In en, this message translates to:
  /// **'Muslim\'s '**
  String get shelf;

  /// No description provided for @muslim.
  ///
  /// In en, this message translates to:
  /// **'shelf'**
  String get muslim;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'As days pass by, a part of you passes too'**
  String get appSlogan;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageApp.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageApp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appTheme;

  /// No description provided for @themeModes.
  ///
  /// In en, this message translates to:
  /// **'Light, Dark, System'**
  String get themeModes;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @alwaysOnDisplay.
  ///
  /// In en, this message translates to:
  /// **'Always-on Display'**
  String get alwaysOnDisplay;

  /// No description provided for @otherApps.
  ///
  /// In en, this message translates to:
  /// **'Our other apps:'**
  String get otherApps;

  /// No description provided for @weSocials.
  ///
  /// In en, this message translates to:
  /// **'Our social media:'**
  String get weSocials;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app:'**
  String get rateApp;

  /// No description provided for @gregorianMonthNames.
  ///
  /// In en, this message translates to:
  /// **'January, February, March, April, May, June, July, August, September, October, November, December'**
  String get gregorianMonthNames;

  /// No description provided for @hijriMonthNames.
  ///
  /// In en, this message translates to:
  /// **'Muharram, Safar, Rabi al-Awwal, Rabi al-Thani, Jumada al-Awwal, Jumada al-Thani, Rajab, Sha\'ban, Ramadan, Shawwal, Dhul-Qa\'dah, Dhul-Hijjah'**
  String get hijriMonthNames;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @prayerParams.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get prayerParams;

  /// No description provided for @selectedCity.
  ///
  /// In en, this message translates to:
  /// **'Current city'**
  String get selectedCity;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @calculationPrayerMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationPrayerMethod;

  /// No description provided for @highLatitude.
  ///
  /// In en, this message translates to:
  /// **'High latitudes'**
  String get highLatitude;

  /// No description provided for @madhabMethod.
  ///
  /// In en, this message translates to:
  /// **'Asr prayer'**
  String get madhabMethod;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get selectCity;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add city'**
  String get addCity;

  /// No description provided for @adjustmentTimes.
  ///
  /// In en, this message translates to:
  /// **'Minute adjustments'**
  String get adjustmentTimes;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @adjustmentMessage.
  ///
  /// In en, this message translates to:
  /// **'If there\'s a slight difference between the calculated prayer times and your local schedule after selecting a calculation method, you can adjust the minutes:'**
  String get adjustmentMessage;

  /// No description provided for @calculationTimeMessage.
  ///
  /// In en, this message translates to:
  /// **'Dear app users!\n\nYou can use the available prayer time calculation methods in the app and additionally make manual time adjustments. If the prayer times still don\'t match your local schedule after these adjustments, we apologize and suggest looking for alternative solutions on Google Play or App Store.\n\nAvailable prayer time calculation methods in the app:'**
  String get calculationTimeMessage;

  /// No description provided for @addCityMessage.
  ///
  /// In en, this message translates to:
  /// **'All fields must be filled.\nLatitude range: -90.0 to 90.0\nLongitude range: -180.0 to 180.0'**
  String get addCityMessage;

  /// No description provided for @enterCountryName.
  ///
  /// In en, this message translates to:
  /// **'Enter country name'**
  String get enterCountryName;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get enterCityName;

  /// No description provided for @enterLatitude.
  ///
  /// In en, this message translates to:
  /// **'Enter latitude (e.g. 21.3924)'**
  String get enterLatitude;

  /// No description provided for @enterLongitude.
  ///
  /// In en, this message translates to:
  /// **'Enter longitude (e.g. 39.8579)'**
  String get enterLongitude;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @invalidCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Invalid coordinates'**
  String get invalidCoordinates;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @defaultAdjustments.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultAdjustments;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset values?'**
  String get resetMessage;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results found for your query'**
  String get searchIsEmpty;

  /// No description provided for @customCityIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any cities'**
  String get customCityIsEmpty;

  /// No description provided for @prayerCalendar.
  ///
  /// In en, this message translates to:
  /// **'Prayer schedule'**
  String get prayerCalendar;

  /// No description provided for @prayerSchedule.
  ///
  /// In en, this message translates to:
  /// **'Monthly schedule'**
  String get prayerSchedule;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dayNumber;

  /// No description provided for @qiblah.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction'**
  String get qiblah;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @adDuhaTime.
  ///
  /// In en, this message translates to:
  /// **'Duha prayer time'**
  String get adDuhaTime;

  /// No description provided for @adhanTime.
  ///
  /// In en, this message translates to:
  /// **'Remembrance during adhan'**
  String get adhanTime;

  /// No description provided for @adhkarsTime.
  ///
  /// In en, this message translates to:
  /// **'Post-prayer remembrance'**
  String get adhkarsTime;

  /// No description provided for @morningAdhkarsTime.
  ///
  /// In en, this message translates to:
  /// **'Morning adhkars time'**
  String get morningAdhkarsTime;

  /// No description provided for @eveningAdhkarsTime.
  ///
  /// In en, this message translates to:
  /// **'Evening adhkars time'**
  String get eveningAdhkarsTime;

  /// No description provided for @nightAdhkarsTime.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget bedtime adhkars!'**
  String get nightAdhkarsTime;

  /// No description provided for @prayerTime.
  ///
  /// In en, this message translates to:
  /// **'Prayer time'**
  String get prayerTime;

  /// No description provided for @remind.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get remind;

  /// No description provided for @adhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get adhan;

  /// No description provided for @adhkars.
  ///
  /// In en, this message translates to:
  /// **'Adhkars'**
  String get adhkars;

  /// No description provided for @morningAdhkars.
  ///
  /// In en, this message translates to:
  /// **'Morning adhkars'**
  String get morningAdhkars;

  /// No description provided for @eveningAdhkars.
  ///
  /// In en, this message translates to:
  /// **'Evening adhkars'**
  String get eveningAdhkars;

  /// No description provided for @nightAdhkars.
  ///
  /// In en, this message translates to:
  /// **'Bedtime adhkars'**
  String get nightAdhkars;

  /// No description provided for @fastMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday fasting'**
  String get fastMonday;

  /// No description provided for @fastThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday fasting'**
  String get fastThursday;

  /// No description provided for @nearWhiteDays.
  ///
  /// In en, this message translates to:
  /// **'White Days are approaching'**
  String get nearWhiteDays;

  /// No description provided for @whiteDays.
  ///
  /// In en, this message translates to:
  /// **'White Days'**
  String get whiteDays;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @tomorrowFriday.
  ///
  /// In en, this message translates to:
  /// **'Indeed, Allah showers His blessings upon the Prophet, and His angels pray for him. O  believers! Invoke Allah’s blessings upon him, and salute him with worthy greetings of peace.\n\nTomorrow is Friday'**
  String get tomorrowFriday;

  /// No description provided for @lastHourFriday.
  ///
  /// In en, this message translates to:
  /// **'Last hour of friday'**
  String get lastHourFriday;

  /// No description provided for @prayerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer notifications'**
  String get prayerNotifications;

  /// No description provided for @adhkarsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Adhkars notifications'**
  String get adhkarsNotifications;

  /// No description provided for @fastingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Fasting notifications'**
  String get fastingNotifications;

  /// No description provided for @fridayNotifications.
  ///
  /// In en, this message translates to:
  /// **'Friday notifications'**
  String get fridayNotifications;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @duha.
  ///
  /// In en, this message translates to:
  /// **'(Duha)'**
  String get duha;

  /// No description provided for @midnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get midnight;

  /// No description provided for @lastThirdNightPart.
  ///
  /// In en, this message translates to:
  /// **'Last ⅓ of the night'**
  String get lastThirdNightPart;

  /// No description provided for @lengthOfDay.
  ///
  /// In en, this message translates to:
  /// **'Length of the day'**
  String get lengthOfDay;

  /// No description provided for @hourMinuteValues.
  ///
  /// In en, this message translates to:
  /// **'hour, hours, hours, minute, minutes, minutes'**
  String get hourMinuteValues;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @week2DayNamesShort.
  ///
  /// In en, this message translates to:
  /// **'Mon, Tue, Wed, Thu, Fri, Sat, Sun'**
  String get week2DayNamesShort;

  /// No description provided for @week2DayNames.
  ///
  /// In en, this message translates to:
  /// **'Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday'**
  String get week2DayNames;

  /// No description provided for @nearFastingDay.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow is a recommended fasting day'**
  String get nearFastingDay;

  /// No description provided for @fastingDay.
  ///
  /// In en, this message translates to:
  /// **'Recommended fasting day'**
  String get fastingDay;

  /// No description provided for @fridaySunans.
  ///
  /// In en, this message translates to:
  /// **'Friday sunnahs'**
  String get fridaySunans;

  /// No description provided for @friday_sunna_1.
  ///
  /// In en, this message translates to:
  /// **'Perform ghusl (major ablution)'**
  String get friday_sunna_1;

  /// No description provided for @friday_sunna_2.
  ///
  /// In en, this message translates to:
  /// **'Groom yourself'**
  String get friday_sunna_2;

  /// No description provided for @friday_sunna_3.
  ///
  /// In en, this message translates to:
  /// **'Wear clean clothes'**
  String get friday_sunna_3;

  /// No description provided for @friday_sunna_4.
  ///
  /// In en, this message translates to:
  /// **'Apply perfume'**
  String get friday_sunna_4;

  /// No description provided for @friday_sunna_5.
  ///
  /// In en, this message translates to:
  /// **'Go to the mosque early'**
  String get friday_sunna_5;

  /// No description provided for @friday_sunna_6.
  ///
  /// In en, this message translates to:
  /// **'Walk to the mosque'**
  String get friday_sunna_6;

  /// No description provided for @friday_sunna_7.
  ///
  /// In en, this message translates to:
  /// **'Sit close to the minbar'**
  String get friday_sunna_7;

  /// No description provided for @friday_sunna_8.
  ///
  /// In en, this message translates to:
  /// **'Step over others except when necessary'**
  String get friday_sunna_8;

  /// No description provided for @friday_sunna_9.
  ///
  /// In en, this message translates to:
  /// **'Talk during the khutbah'**
  String get friday_sunna_9;

  /// No description provided for @friday_sunna_10.
  ///
  /// In en, this message translates to:
  /// **'Pray 4 rak\'ahs (2+2) after Jumu\'ah at the mosque or 2 rak\'ahs at home'**
  String get friday_sunna_10;

  /// No description provided for @friday_sunna_11.
  ///
  /// In en, this message translates to:
  /// **'Read Surah Al-Kahf'**
  String get friday_sunna_11;

  /// No description provided for @friday_sunna_12.
  ///
  /// In en, this message translates to:
  /// **'Send abundant blessings upon the Prophet ﷺ'**
  String get friday_sunna_12;

  /// No description provided for @friday_sunna_13.
  ///
  /// In en, this message translates to:
  /// **'Make dua during the last hour of Friday\n(one hour before Maghrib)'**
  String get friday_sunna_13;

  /// No description provided for @mustahab.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get mustahab;

  /// No description provided for @haram.
  ///
  /// In en, this message translates to:
  /// **'Forbidden (Haram)'**
  String get haram;

  /// No description provided for @lastFridayHour.
  ///
  /// In en, this message translates to:
  /// **'Last hour of friday'**
  String get lastFridayHour;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @seasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get seasonSpring;

  /// No description provided for @seasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get seasonSummer;

  /// No description provided for @seasonFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get seasonFall;

  /// No description provided for @seasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get seasonWinter;

  /// No description provided for @daysToRamadan.
  ///
  /// In en, this message translates to:
  /// **'Days until ramadan'**
  String get daysToRamadan;

  /// No description provided for @blessedRamadan.
  ///
  /// In en, this message translates to:
  /// **'Blessed ramadan'**
  String get blessedRamadan;

  /// No description provided for @daysToDhulHujjah.
  ///
  /// In en, this message translates to:
  /// **'Days until Dhul-Hijjah'**
  String get daysToDhulHujjah;

  /// No description provided for @dhulHijjah.
  ///
  /// In en, this message translates to:
  /// **'Fasting in Dhul-Hijjah'**
  String get dhulHijjah;

  /// No description provided for @congratulationRamadan.
  ///
  /// In en, this message translates to:
  /// **'Eid Mubarak!\nMay Allah accept it from us and you!'**
  String get congratulationRamadan;

  /// No description provided for @congratulationDhulHijjah.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha Mubarak!\nMay Allah accept it from us and you!'**
  String get congratulationDhulHijjah;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @startRamadan.
  ///
  /// In en, this message translates to:
  /// **'Beginning of Ramadan'**
  String get startRamadan;

  /// No description provided for @idAlFitr.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get idAlFitr;

  /// No description provided for @startDhulHijjah.
  ///
  /// In en, this message translates to:
  /// **'Beginning of Dhul-Hijjah'**
  String get startDhulHijjah;

  /// No description provided for @dayArafa.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafah'**
  String get dayArafa;

  /// No description provided for @idAlAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha'**
  String get idAlAdha;

  /// No description provided for @dayAshura.
  ///
  /// In en, this message translates to:
  /// **'Day of Ashura'**
  String get dayAshura;

  /// No description provided for @backgroundWarmth.
  ///
  /// In en, this message translates to:
  /// **'Background warmth'**
  String get backgroundWarmth;

  /// No description provided for @textContrast.
  ///
  /// In en, this message translates to:
  /// **'Text contrast'**
  String get textContrast;

  /// No description provided for @ayahDay.
  ///
  /// In en, this message translates to:
  /// **'Verse of the Day'**
  String get ayahDay;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @sQuran.
  ///
  /// In en, this message translates to:
  /// **'Quranic supplications'**
  String get sQuran;

  /// No description provided for @fortress.
  ///
  /// In en, this message translates to:
  /// **'Adhkars'**
  String get fortress;

  /// No description provided for @gems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

  /// No description provided for @counter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counter;

  /// No description provided for @fortressMuslim.
  ///
  /// In en, this message translates to:
  /// **'Fortress of the muslim'**
  String get fortressMuslim;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @fortressChapterTableName.
  ///
  /// In en, this message translates to:
  /// **'Table_of_chapters_en'**
  String get fortressChapterTableName;

  /// No description provided for @fortressFootnoteTableName.
  ///
  /// In en, this message translates to:
  /// **'Table_of_footnotes_en'**
  String get fortressFootnoteTableName;

  /// No description provided for @fortressTableName.
  ///
  /// In en, this message translates to:
  /// **'Table_of_supplications_en'**
  String get fortressTableName;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @istikhara.
  ///
  /// In en, this message translates to:
  /// **'Istikhara'**
  String get istikhara;

  /// No description provided for @afterPrayer.
  ///
  /// In en, this message translates to:
  /// **'After prayer'**
  String get afterPrayer;

  /// No description provided for @sfqTableName.
  ///
  /// In en, this message translates to:
  /// **'Table_of_supplications_en'**
  String get sfqTableName;

  /// No description provided for @randomAyah.
  ///
  /// In en, this message translates to:
  /// **'Random verse'**
  String get randomAyah;

  /// No description provided for @randomCitation.
  ///
  /// In en, this message translates to:
  /// **'Random quote'**
  String get randomCitation;

  /// No description provided for @arabicTextSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic text size'**
  String get arabicTextSize;

  /// No description provided for @translationTextSize.
  ///
  /// In en, this message translates to:
  /// **'Translation text size'**
  String get translationTextSize;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @transcription.
  ///
  /// In en, this message translates to:
  /// **'Transcription'**
  String get transcription;

  /// No description provided for @surahKahf.
  ///
  /// In en, this message translates to:
  /// **'Surah Al-Kahf'**
  String get surahKahf;

  /// No description provided for @surahSajda.
  ///
  /// In en, this message translates to:
  /// **'Surah As-Sajdah'**
  String get surahSajda;

  /// No description provided for @surahMulk.
  ///
  /// In en, this message translates to:
  /// **'Surah Al-Mulk'**
  String get surahMulk;

  /// No description provided for @djuzAmma.
  ///
  /// In en, this message translates to:
  /// **'Juz \'Amma'**
  String get djuzAmma;

  /// No description provided for @timeOffset.
  ///
  /// In en, this message translates to:
  /// **'Daylight saving time (DST)'**
  String get timeOffset;

  /// No description provided for @salawatButton.
  ///
  /// In en, this message translates to:
  /// **'Send blessings upon the Prophet ﷺ'**
  String get salawatButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'ka',
    'kk',
    'ky',
    'ru',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
