import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Prayer/HijriMiladiTimes.dart';
import 'package:sally_prayer_times/Prayer/PrayersTimes.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../Classes/PreferenceUtils.dart';
import '../Providers/ThemeProvider.dart';


enum TimeType {
  hijri,
  miladi
}

class CalendarPage extends StatefulWidget{
  CalendarPage({Key? key}) : super(key: key);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>{

  ScreenshotController screenshotController = ScreenshotController();

  final formatter = new intl.NumberFormat("00");
  Table calendarTable = Table();
  String actualDate = '';
  TimeType timeType = TimeType.miladi;
  late HijriCalendar hijriCalendar;
  late String selectedCalendarType;
  List<String> calendarTypeList = [
    Configuration.CALENDAR_TYPE_MILADI,
    Configuration.CALENDAR_TYPE_HIJRI,
  ];

  @override
  void dispose(){
  }

  @override
  void initState(){
    super.initState();

    if(SettingsProvider().calendarType == Configuration.CALENDAR_TYPE_MILADI){
      timeType = TimeType.miladi;
    }else{
      timeType = TimeType.hijri;
    }
    setState(() {
      selectedCalendarType = translate(SettingsProvider().calendarType);
    });
    generateTable(DateTime.now());
  }

  static const List<int> _daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear)
        return 29;
      return 28;
    }
    return _daysInMonth[month - 1];
  }

  generateTable(DateTime selectedDateTime){
    int daysInMonth = getDaysInMonth(selectedDateTime.year, selectedDateTime.month);
    if(timeType == TimeType.hijri){
      if(selectedDateTime.year == DateTime.now().year && selectedDateTime.month == DateTime.now().month){
        selectedDateTime = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+int.parse(PreferenceUtils.getString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, '0')));
      }else{
        selectedDateTime = DateTime.utc(selectedDateTime.year,selectedDateTime.month,selectedDateTime.day+int.parse(PreferenceUtils.getString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, '0')));
      }
      hijriCalendar = new HijriCalendar.fromDate(selectedDateTime);
      daysInMonth = hijriCalendar.lengthOfMonth;
      setState(() {
        actualDate = HijriTime().getHijriMonthFromValue(hijriCalendar.hMonth)!+' '+hijriCalendar.hYear.toString();
      });
    }else{
      daysInMonth = getDaysInMonth(selectedDateTime.year, selectedDateTime.month);
      setState(() {
        actualDate = MiladiTime().getMiladiMonthFromValue(selectedDateTime.month)! + ' ' + selectedDateTime.year.toString();
      });
    }

    List<TableRow> rows = [];
    if(timeType == TimeType.hijri){
      rows.add(TableRow(children: [
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(MiladiTime().getMiladiMonthFromValue(selectedDateTime.month)!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(HijriTime().getHijriMonthFromValue(hijriCalendar.hMonth)!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('fajr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('duhr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('asr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('maghrib'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('ishaa'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
      ], decoration: BoxDecoration(color: ThemeProvider().appBarColor),));
    }else{
      rows.add(TableRow(children: [
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(MiladiTime().getMiladiMonthFromValue(selectedDateTime.month)!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('fajr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('duhr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('asr'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('maghrib'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(translate('ishaa'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white,)),),
      ], decoration: BoxDecoration(color: ThemeProvider().appBarColor),));
    }
    for (int i = 1 ; i < daysInMonth+1 ; i++) {
      if(timeType == TimeType.hijri){
        DateTime gregorianFromHijri = hijriCalendar.hijriToGregorian(hijriCalendar.hYear, hijriCalendar.hMonth, i);
        PrayerTimes prayerTimes = new PrayerTimes(i, gregorianFromHijri.month, gregorianFromHijri.year);
        rows.add(TableRow(children: [
          TableCell(verticalAlignment: TableCellVerticalAlignment.fill, child: Container(color: ThemeProvider().appBarColor, child: Text((gregorianFromHijri.day.toString()+ ' ' +MiladiTime().getMiladiMonthAbbreviations(gregorianFromHijri.month)!),textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, backgroundColor: ThemeProvider().appBarColor)),),),
          TableCell(verticalAlignment: TableCellVerticalAlignment.fill, child: Container(color: ThemeProvider().appBarColor, child: Text((i.toString()),textAlign: TextAlign.center , style: TextStyle(color: Colors.white, backgroundColor: ThemeProvider().appBarColor)),),),
          Text(prayerTimes.fajrTime),
          Text(prayerTimes.duhrime),
          Text(prayerTimes.asrTime),
          Text(prayerTimes.maghribTime),
          Text(prayerTimes.ishaaTime),
        ]));
      }else{
        PrayerTimes prayerTimes = new PrayerTimes(i, selectedDateTime.month, selectedDateTime.year);
        rows.add(TableRow(children: [
          TableCell(verticalAlignment: TableCellVerticalAlignment.fill, child: Container(color: ThemeProvider().appBarColor, child: Text((i.toString()),textAlign: TextAlign.center , style: TextStyle(color: Colors.white, backgroundColor: ThemeProvider().appBarColor)),),),
          Text(prayerTimes.fajrTime),
          Text(prayerTimes.duhrime),
          Text(prayerTimes.asrTime),
          Text(prayerTimes.maghribTime),
          Text(prayerTimes.ishaaTime),
        ]));
      }
    }

    Map<int, TableColumnWidth> columnsWidths = {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1),
      2: FlexColumnWidth(1),
      3: FlexColumnWidth(1),
      4: FlexColumnWidth(1),
      5: FlexColumnWidth(1),
    };

    if(timeType == TimeType.hijri){
      columnsWidths = {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      };
    }

    setState(() {
      calendarTable = Table(children: rows, border: TableBorder.all(
        color: Colors.grey,
        style: BorderStyle.solid,
        width: 0.5,
      ),columnWidths: columnsWidths);
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xf5f5f7),
      body: Center(
          child: Container(
              child: new SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: statusBarHeight,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            child: Text(translate('calendar_type')),
                          ),
                          DropdownButton<String>(hint: Text(selectedCalendarType),
                            items: calendarTypeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(translate(value)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if(calendarTypeList.indexOf(newValue!) == 0){
                                SettingsProvider().calendarType = Configuration.CALENDAR_TYPE_MILADI;
                                timeType = TimeType.miladi;
                              }else{
                                SettingsProvider().calendarType = Configuration.CALENDAR_TYPE_HIJRI;
                                timeType = TimeType.hijri;
                              }
                              setState(() {
                                selectedCalendarType = translate(SettingsProvider().calendarType);
                              });
                              generateTable(DateTime.now());
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final selected = await showMonthYearPicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(3000),
                                  locale: SettingsProvider().language == Configuration.arabicKey ? Locale(Configuration.arabicKey) : Locale(Configuration.englishKey),
                                );
                                if(selected != null){
                                  generateTable(selected);
                                }
                              },
                              label: Text(translate('select_date')),
                              icon: Icon(
                                FontAwesome.calendar,
                                size: 20.0,
                              ), // <-- Text
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            child: IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                                  if (image != null) {
                                    final directory = await getApplicationDocumentsDirectory();
                                    if(File('${directory.path}/calendar.png').exists() == true){
                                      File('${directory.path}/calendar.png').delete();
                                    }
                                    final imagePath = await File('${directory.path}/calendar.png').create();
                                    print(imagePath);
                                    await imagePath.writeAsBytes(image);
                                    await Share.shareFiles([imagePath.path]);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                              ? Colors.transparent
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(actualDate, style: TextStyle(fontSize: 18),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, right: 5, left: 5),
                                child: calendarTable,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              )
          )
      ),
    );
  }

}