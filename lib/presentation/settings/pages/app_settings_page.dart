import 'package:flutter/material.dart';

import '../../../core/styles/app_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/app_locale_drop_down.dart';
import '../widgets/app_wake_lock.dart';
import '../widgets/day_length.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocale.settings),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.mainMardingMini,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLocaleDropDown(),
            const Divider(indent: 16, endIndent: 16),
            const ThemeModeDropDown(),
            const Divider(indent: 16, endIndent: 16),
            const ThemeColorPicker(),
            const Divider(indent: 16, endIndent: 16),
            const AppWakeLock(),
            const Divider(indent: 16, endIndent: 16),
            const DayLength(),
            const Divider(indent: 16, endIndent: 16),
          ],
        ),
      ),
    );
  }
}
