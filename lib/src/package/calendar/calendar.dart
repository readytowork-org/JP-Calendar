import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../month/month_header.dart';
import '../month/month_picker.dart';
import '../widgets/cancel_ok_button.dart';
import '../year/year_header.dart';
import '../year/year_picker.dart' as ENJP;
import 'calendar_header.dart';

class Calendar extends StatefulWidget {
  final DateTimeCallback dateTimeCallback;

  const Calendar({super.key, required this.dateTimeCallback});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final headerNotifier = ValueNotifier<int>(0);
  final dayTimeListener = ValueNotifier<List<int>>([]);
  final monthListener = ValueNotifier<int>(0);
  late final PageController _monthPageController;
  final dropDownJPERaListener = ValueNotifier<String>(YearType.english);
  final selectedYearListener =
      ValueNotifier<String>(DateTime.now().year.toString());
  late final PageController _pageController;
  int index = 0;
  @override
  void initState() {
    YearFactory.getYears();
    _monthPageController = PageController(initialPage: 0);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        height: 510,
        width: double.infinity,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            CalendarHeader(
              headerBackgroundColor: Colors.blue,
              dateTimeListenable: dayTimeListener,
            ),
            Container(
              height: 370,
              color: Colors.white,
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: headerNotifier,
                      builder: (context, header, _) {
                        return header == 0
                            ? YearHeader(
                                dropDownJPERaListener: dropDownJPERaListener)
                            : MonthHeader(
                                yearListener: selectedYearListener,
                                onPressed: () {
                                  _pageController.jumpToPage(0);
                                  headerNotifier.value = 0;
                                },
                                monthListener: monthListener,
                                monthSwitchController: _monthPageController);
                      }),
                  const Divider(),
                  Flexible(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ENJP.YearPicker(
                          jpEnYearNotifier: dropDownJPERaListener,
                          onYearChanged: (year) {
                            _pageController.jumpToPage(1);
                            headerNotifier.value = 1;
                            selectedYearListener.value = year;
                          },
                        ),
                        MonthPicker(
                          pageController: _monthPageController,
                          monthNotifier: monthListener,
                          yearNotifier: selectedYearListener,
                          dayTimeNotifier: dayTimeListener,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  CancelOkButton(
                    onSubmit: () {
                      if (headerNotifier.value == 1) {
                        widget.dateTimeCallback(getSelectedDateTime(
                            selectedYearListener.value, dayTimeListener.value));
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
