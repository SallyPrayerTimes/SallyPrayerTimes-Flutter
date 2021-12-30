import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Prayer/AthanServiceManager.dart';
import 'package:sally_prayer_times/Prayer/HijriMiladiTimes.dart';
import 'package:sally_prayer_times/Providers/PrayersProvider.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';

class PrayersPage extends StatefulWidget{
  PrayersPage({Key? key}) : super(key: key);
  @override
  _PrayersPageState createState() => _PrayersPageState();
}

class _PrayersPageState extends State<PrayersPage> with WidgetsBindingObserver{

  final formatter = new intl.NumberFormat("00");
  bool isStopped = false;
  String nextPrayerLabel = translate('Next_Prayer');

  late Timer _timer;

  @override
  void dispose(){
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    isStopped = true;
    try{_timer.cancel();}catch(e){}
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    refreshNextPrayerTime();
  }

  void refreshNextPrayerTime() async{
    try{_timer.cancel();}catch(e){}
    await AthanServiceManager.getPrayerTimes();
    ThemeProvider().refreshColors();
    setState(() {
      nextPrayerLabel = translate('Next_Prayer');
    });
    if(PrayersProvider().nextPrayerTimeCode < 6){
      late int nextPrayerTimeValue;
      switch(PrayersProvider().nextPrayerTimeCode){
        case 0: {nextPrayerTimeValue = PrayersProvider().fajrTimeInMinutes;} break;
        case 1: {nextPrayerTimeValue = PrayersProvider().shoroukTimeInMinutes;} break;
        case 2: {nextPrayerTimeValue = PrayersProvider().duhrTimeInMinutes;} break;
        case 3: {nextPrayerTimeValue = PrayersProvider().asrTimeInMinutes;} break;
        case 4: {nextPrayerTimeValue = PrayersProvider().maghribTimeInMinutes;} break;
        case 5: {nextPrayerTimeValue = PrayersProvider().ishaaTimeInMinutes;} break;
      }

      DateTime nextPrayerDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, nextPrayerTimeValue ~/ 60, nextPrayerTimeValue % 60);

      _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        if (isStopped) {
          timer.cancel();
        }else{
          try{
            Duration duration = nextPrayerDateTime.difference(DateTime.now());
            if(duration.isNegative){
              if(duration.inSeconds == -60){
                refreshNextPrayerTime();
              }
              setState(() {
                nextPrayerLabel = translate('It_s_time_of')+' ';
              });
              Provider.of<PrayersProvider>(context, listen: false).nextPrayerTime = Provider.of<PrayersProvider>(context, listen: false).nextPrayerName;
            } else{
              Provider.of<PrayersProvider>(context, listen: false).nextPrayerTime = _printDuration(duration);
            }
          }catch(e){}
        }
      });
    }else{
      Provider.of<PrayersProvider>(context, listen: false).nextPrayerName = translate('fajr');
      Provider.of<PrayersProvider>(context, listen: false).nextPrayerTime = translate('fajr');
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed: isStopped = false; try{_timer.cancel();}catch(e){}; refreshNextPrayerTime(); break;
      case AppLifecycleState.inactive: isStopped = true; break;
      case AppLifecycleState.paused: isStopped = true; break;
      case AppLifecycleState.detached: isStopped = true; break;
    }
  }

  void athanNotificationIconHandler(int prayerTimesNumber) async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: translate('athan'), key: 81,),
      AlertDialogAction(label: translate('notification'), key: 82),
      AlertDialogAction(label: translate('vibration'), key: 83),
      AlertDialogAction(label: translate('nothing'), key: 84),
    ];
    var athanType = await showConfirmationDialog(context: context, title: translate('Athan_Type'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(athanType != null){
      String finalAthanType = Configuration.athanKey;
      switch(athanType){
        case 81: {finalAthanType = Configuration.athanKey;} break;
        case 82: {finalAthanType = Configuration.notificationKey;} break;
        case 83: {finalAthanType = Configuration.vibrationKey;} break;
        case 84: {finalAthanType = Configuration.nothingKey;} break;
        default: {finalAthanType = Configuration.athanKey;} break;
      }

      switch(prayerTimesNumber){
        case 1: {Provider.of<PrayersProvider>(context, listen: false).fajrAthanType = finalAthanType;} break;
        case 2: {Provider.of<PrayersProvider>(context, listen: false).shoroukAthanType = finalAthanType;} break;
        case 3: {Provider.of<PrayersProvider>(context, listen: false).duhrAthanType = finalAthanType;} break;
        case 4: {Provider.of<PrayersProvider>(context, listen: false).asrAthanType = finalAthanType;} break;
        case 5: {Provider.of<PrayersProvider>(context, listen: false).maghribAthanType = finalAthanType;} break;
        case 6: {Provider.of<PrayersProvider>(context, listen: false).ishaaAthanType = finalAthanType;} break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    Locale appLocale = Localizations.localeOf(context);
    double nextPrayerTimeFontSize = appLocale.languageCode == Configuration.arabicKey ? 20.0 : 35.0;
    return Scaffold(
      backgroundColor: Color(0xf5f5f7),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context, listen: true).appBarColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.zero, topRight: Radius.zero, bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/appbar/islamic_mosque.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: statusBarHeight,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          formatter.format(DateTime.now().day), style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          MiladiTime().miladiMonth!, style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          DateTime.now().year.toString(), style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: statusBarHeight,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 0, right: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          formatter.format(Provider.of<SettingsProvider>(context, listen: true).hijriDay), style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Provider.of<SettingsProvider>(context, listen: true).hijriMonth!, style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Provider.of<SettingsProvider>(context, listen: true).hijriYear.toString(), style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 10.0),
                                        child: Provider.of<SettingsProvider>(context, listen: true).language == Configuration.arabicKey ?
                                        Text(Provider.of<PrayersProvider>(context, listen: true).nextPrayerName, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),) :
                                        Text(nextPrayerLabel, style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.w600))
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 10.0),
                                          child: Provider.of<SettingsProvider>(context, listen: true).language == Configuration.arabicKey ?
                                          Text(nextPrayerLabel, style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.w600)) :
                                          Text(Provider.of<PrayersProvider>(context, listen: true).nextPrayerName, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),)
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 5.0),
                                        child: Text(
                                          Provider.of<PrayersProvider>(context, listen: true).nextPrayerTime, style: TextStyle(color: Colors.white, fontSize: nextPrayerTimeFontSize, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 0, right: 0, left: 5.0),
                                        child: Icon(Icons.place, color: Colors.white,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 0, right: 0, left: 0.0),
                                        child: Text(
                                          (Provider.of<SettingsProvider>(context, listen: true).country + ' / ' +Provider.of<SettingsProvider>(context, listen: true).city).length > 35 ? (Provider.of<SettingsProvider>(context, listen: true).country + ' / ' +Provider.of<SettingsProvider>(context, listen: true).city).substring(0,35) : (Provider.of<SettingsProvider>(context, listen: true).country + ' / ' +Provider.of<SettingsProvider>(context, listen: true).city), style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.fromLTRB(10.0, 20, 10.0, 20.0),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 6.0,
                    children: <Widget>[
                      getPrayerContainer('fajr',Provider.of<PrayersProvider>(context, listen: true).fajrTime,Provider.of<PrayersProvider>(context, listen: true).fajrPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).fajrPrayerColor,(){athanNotificationIconHandler(1);}),
                      getPrayerContainer('shorouk',Provider.of<PrayersProvider>(context, listen: true).shoroukTime,Provider.of<PrayersProvider>(context, listen: true).shoroukPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).shoroukPrayerColor,(){athanNotificationIconHandler(2);}),
                      getPrayerContainer('duhr',Provider.of<PrayersProvider>(context, listen: true).duhrTime,Provider.of<PrayersProvider>(context, listen: true).duhrPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).duhrPrayerColor,(){athanNotificationIconHandler(3);}),
                      getPrayerContainer('asr',Provider.of<PrayersProvider>(context, listen: true).asrTime,Provider.of<PrayersProvider>(context, listen: true).asrPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).asrPrayerColor,(){athanNotificationIconHandler(4);}),
                      getPrayerContainer('maghrib',Provider.of<PrayersProvider>(context, listen: true).maghribTime,Provider.of<PrayersProvider>(context, listen: true).maghribPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).maghribPrayerColor,(){athanNotificationIconHandler(5);}),
                      getPrayerContainer('ishaa',Provider.of<PrayersProvider>(context, listen: true).ishaaTime,Provider.of<PrayersProvider>(context, listen: true).ishaaPrayerIcon,Provider.of<ThemeProvider>(context, listen: true).ishaaPrayerColor,(){athanNotificationIconHandler(6);}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container getPrayerContainer(String prayerName, String prayerTime, IconData prayerAthanNotificationIcon, Color prayersColor, Function notificationAthanIconOnPressedFunction){
    if(DateTime.now().weekday == 5 && prayerName == 'duhr'){
      prayerName = 'jumuah';
    };
    return Container(
      height: 15,
      decoration: BoxDecoration(
        border: Border.all(color: prayersColor, width: 0.2),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: prayersColor,
            blurRadius: 1.0,
            offset: Offset(1.0, 1.0),
          )
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 10),
                      child: Text(
                        translate(prayerName), style: TextStyle(color: prayersColor, fontSize: 14.0, fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 10),
                      child:Text(prayerTime, style: TextStyle(color: prayersColor, fontSize: 14.0, fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(icon: Icon(prayerAthanNotificationIcon, color: prayersColor,), onPressed: notificationAthanIconOnPressedFunction as void Function()?,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}