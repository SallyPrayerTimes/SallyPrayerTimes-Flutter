import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Providers/PrayersProvider.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';

class AthanServiceManager{

  static final AthanServiceManager _AthanServiceManager = new AthanServiceManager._internal();
  factory AthanServiceManager() {
    return _AthanServiceManager;
  }
  AthanServiceManager._internal();

  static const methodChannel = const MethodChannel('com.sallyprayertimes/sallyprayertimeschannel');

  static void startService() async{
    await methodChannel.invokeMethod("startService");
    await getPrayerTimes();
  }

  static void getPrayerTimes() async{
    List<dynamic> data = <dynamic>[];
    data = await methodChannel.invokeMethod("getPrayersTimes");
    PrayersProvider().nextPrayerTimeCode = int.parse(data[0]);
    PrayersProvider().fajrTimeInMinutes = int.parse(data[1]);
    PrayersProvider().shoroukTimeInMinutes = int.parse(data[2]);
    PrayersProvider().duhrTimeInMinutes = int.parse(data[3]);
    PrayersProvider().asrTimeInMinutes = int.parse(data[4]);
    PrayersProvider().maghribTimeInMinutes = int.parse(data[5]);
    PrayersProvider().ishaaTimeInMinutes = int.parse(data[6]);

    PrayersProvider().fajrTime = getFinaleSalatTime(PrayersProvider().fajrTimeInMinutes);
    PrayersProvider().shoroukTime = getFinaleSalatTime(PrayersProvider().shoroukTimeInMinutes);
    PrayersProvider().duhrTime = getFinaleSalatTime(PrayersProvider().duhrTimeInMinutes);
    PrayersProvider().asrTime = getFinaleSalatTime(PrayersProvider().asrTimeInMinutes);
    PrayersProvider().maghribTime = getFinaleSalatTime(PrayersProvider().maghribTimeInMinutes);
    PrayersProvider().ishaaTime = getFinaleSalatTime(PrayersProvider().ishaaTimeInMinutes);

    switch(PrayersProvider().nextPrayerTimeCode){
      case 0: {PrayersProvider().nextPrayerTime = PrayersProvider().fajrTime;PrayersProvider().nextPrayerName = translate('fajr');} break;
      case 1: {PrayersProvider().nextPrayerTime = PrayersProvider().shoroukTime;PrayersProvider().nextPrayerName = translate('shorouk');} break;
      case 2: {
        if(DateTime.now().weekday == 5){
          PrayersProvider().nextPrayerTime = PrayersProvider().duhrTime;PrayersProvider().nextPrayerName = translate('jumuah');
        }else{
          PrayersProvider().nextPrayerTime = PrayersProvider().duhrTime;PrayersProvider().nextPrayerName = translate('duhr');
        }
      } break;
      case 3: {PrayersProvider().nextPrayerTime = PrayersProvider().asrTime;PrayersProvider().nextPrayerName = translate('asr');} break;
      case 4: {PrayersProvider().nextPrayerTime = PrayersProvider().maghribTime;PrayersProvider().nextPrayerName = translate('maghrib');} break;
      case 5: {PrayersProvider().nextPrayerTime = PrayersProvider().ishaaTime;PrayersProvider().nextPrayerName = translate('ishaa');} break;
    }
  }

  static String getFinaleSalatTime(int salatTime)
  {
    int salatHour = salatTime ~/ 60;
    int salatMinutes = salatTime % 60;

    if ((SettingsProvider().time12_24 == Configuration.time12or24_12) && (salatHour > 12)) {
      salatHour -= 12;
    }
    return (salatHour.toString().padLeft(2, '0') + ":" + salatMinutes.toString().padLeft(2, '0'));
  }

}