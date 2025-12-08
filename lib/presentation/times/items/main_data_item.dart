import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../core/styles/app_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../state/time_state.dart';

class MainDataItem extends StatelessWidget {
  const MainDataItem({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    final appColors = Theme.of(context).colorScheme;
    return Consumer<TimeState>(
      builder: (context, timeState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                color: appColors.surface,
                margin: AppStyles.mardingTopMini,
                child: Center(
                  child: ListTile(
                    contentPadding: AppStyles.mardingHorizontalMini,
                    visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                    splashColor: Colors.transparent,
                    shape: AppStyles.mainShapeMini,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => IgnorePointer(
                          child: Padding(
                            padding: AppStyles.mardingHorizontalMini,
                            child: SfDateRangePicker(
                              headerHeight: 0,
                              todayHighlightColor: Colors.transparent,
                              enablePastDates: false,
                              view: DateRangePickerView.month,
                              backgroundColor: appColors.surfaceContainerLow,
                              allowViewNavigation: false,
                              showTodayButton: false,
                              showNavigationArrow: false,
                              monthViewSettings: const DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1,
                                weekendDays: <int>[5],
                              ),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                todayCellDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(color: appColors.tertiary, width: 1.5),
                                ),
                                todayTextStyle: TextStyle(
                                  color: appColors.tertiary,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                weekendTextStyle: TextStyle(
                                  color: appColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(
                      appLocale.gregorianMonthNames.split(', ')[timeState.getDateTime.month - 1],
                      style: TextStyle(color: appColors.tertiary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('${timeState.getDateTime.year} ${appLocale.year.toLowerCase()}'),
                    leading: CircleAvatar(
                      backgroundColor: appColors.tertiaryContainer,
                      child: Padding(
                        padding: AppStyles.mardingTopMicroMini,
                        child: Text(
                          '${timeState.getDateTime.day}',
                          style: TextStyle(color: appColors.tertiary),
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                color: appColors.surface,
                margin: AppStyles.mardingBottomMini,
                child: Center(
                  child: ListTile(
                    contentPadding: AppStyles.mardingHorizontalMini,
                    visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                    splashColor: Colors.transparent,
                    shape: AppStyles.mainShapeMini,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (newContext) => IgnorePointer(
                          child: Padding(
                            padding: AppStyles.mardingHorizontalMini,
                            child: SfHijriDateRangePicker(
                              headerHeight: 0,
                              todayHighlightColor: Colors.transparent,
                              enablePastDates: false,
                              view: HijriDatePickerView.month,
                              backgroundColor: appColors.surfaceContainerLow,
                              allowViewNavigation: false,
                              showTodayButton: false,
                              showNavigationArrow: false,
                              monthViewSettings: HijriDatePickerMonthViewSettings(
                                firstDayOfWeek: 1,
                                weekendDays: <int>[5],
                              ),
                              monthCellStyle: HijriDatePickerMonthCellStyle(
                                todayCellDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(color: appColors.tertiary, width: 1.5),
                                ),
                                todayTextStyle: TextStyle(
                                  color: appColors.tertiary,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                weekendTextStyle: TextStyle(
                                  color: appColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(
                      appLocale.hijriMonthNames.split(', ')[timeState.getHijriDateTime.hMonth - 1],
                      style: TextStyle(color: appColors.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${timeState.getHijriDateTime.hYear} ${appLocale.year.toLowerCase()}',
                      style: TextStyle(),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: appColors.primaryContainer,
                      child: Padding(
                        padding: AppStyles.mardingTopMicroMini,
                        child: Text(
                          '${timeState.getHijriDateTime.hDay}',
                          style: TextStyle(color: appColors.primary),
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right_rounded),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
