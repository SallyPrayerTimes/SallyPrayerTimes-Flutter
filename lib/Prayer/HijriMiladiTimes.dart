
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';

class HijriTime{
  static final HijriTime _HijriTime = new HijriTime._internal();
  static late HijriCalendar hijriCalendar;
  factory HijriTime() {
    DateTime dateTimeNow = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+int.parse(PreferenceUtils.getString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, '0')));
    hijriCalendar = new HijriCalendar.fromDate(dateTimeNow);
    return _HijriTime;
  }
  HijriTime._internal();

  void init(){
    DateTime dateTimeNow = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+int.parse(PreferenceUtils.getString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, '0')));
    hijriCalendar = new HijriCalendar.fromDate(dateTimeNow);
  }

  int? _hijriDay;
  int? get hijriDay{
    _hijriDay = hijriCalendar.hDay;
    return _hijriDay;
  }
  set hijriDay(int? value) {
    _hijriDay = value;
  }

  String? _hijriMonth;
  String? get hijriMonth{
    switch(hijriCalendar.hMonth){
      case 1: {_hijriMonth = translate('Muharram');} break;
      case 2: {_hijriMonth = translate('Safar');} break;
      case 3: {_hijriMonth = translate('Rabi_Al_Awwal');} break;
      case 4: {_hijriMonth = translate('Rabi_Al_Thani');} break;
      case 5: {_hijriMonth = translate('Jumada_Al_Awwal');} break;
      case 6: {_hijriMonth = translate('Jumada_Al_Thani');} break;
      case 7: {_hijriMonth = translate('Rajab');} break;
      case 8: {_hijriMonth = translate('Sha_aban');} break;
      case 9: {_hijriMonth = translate('Ramadan');} break;
      case 10: {_hijriMonth = translate('Shawwal');} break;
      case 11: {_hijriMonth = translate('Dhu_Al_Qi_dah');} break;
      case 12: {_hijriMonth = translate('Dhu_Al_Hijjah');} break;
    }
    return _hijriMonth;
  }
  set hijriMonth(String? value) {
    _hijriMonth = value;
  }

  String? getHijriMonthFromValue(int monthNUmber){
    switch(monthNUmber){
      case 1: {return translate('Muharram');}
      case 2: {return translate('Safar');}
      case 3: {return translate('Rabi_Al_Awwal');}
      case 4: {return translate('Rabi_Al_Thani');}
      case 5: {return translate('Jumada_Al_Awwal');}
      case 6: {return translate('Jumada_Al_Thani');}
      case 7: {return translate('Rajab');}
      case 8: {return translate('Sha_aban');}
      case 9: {return translate('Ramadan');}
      case 10: {return translate('Shawwal');}
      case 11: {return translate('Dhu_Al_Qi_dah');}
      case 12: {return translate('Dhu_Al_Hijjah');}
    }
  }

  int? _hijriYear;
  int? get hijriYear{
    _hijriYear = hijriCalendar.hYear;
    return _hijriYear;
  }
  set hijriYear(int? value) {
    _hijriYear = value;
  }

  bool _isRamadan = false;
  bool get isRamadan{
    DateTime dateTimeNow = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+int.parse(SettingsProvider().hijriAdjustment));
    HijriCalendar hijriCalendar = new HijriCalendar.fromDate(dateTimeNow);
    if(hijriCalendar.hMonth == 9){
      _isRamadan = true;
    }
    return _isRamadan;
  }
  set isRamadan(bool value) {
    _isRamadan = value;
  }
}

class MiladiTime{
  static final MiladiTime _MiladiTime = new MiladiTime._internal();
  factory MiladiTime() {
    return _MiladiTime;
  }
  MiladiTime._internal();

  String? _miladiMonth;
  String? get miladiMonth{
    switch(DateTime.now().month){
      case 1: {_miladiMonth = translate('January');} break;
      case 2: {_miladiMonth = translate('February');} break;
      case 3: {_miladiMonth = translate('March');} break;
      case 4: {_miladiMonth = translate('April');} break;
      case 5: {_miladiMonth = translate('May');} break;
      case 6: {_miladiMonth = translate('June');} break;
      case 7: {_miladiMonth = translate('July');} break;
      case 8: {_miladiMonth = translate('August');} break;
      case 9: {_miladiMonth = translate('September');} break;
      case 10: {_miladiMonth = translate('October');} break;
      case 11: {_miladiMonth = translate('November');} break;
      case 12: {_miladiMonth = translate('December');} break;
    }
    return _miladiMonth;
  }
  set miladiMonth(String? value) {
    _miladiMonth = value;
  }

  String? getMiladiMonthFromValue(int monthNumber){
    switch(monthNumber){
      case 1: {return translate('January');}
      case 2: {return translate('February');}
      case 3: {return translate('March');}
      case 4: {return translate('April');}
      case 5: {return translate('May');}
      case 6: {return translate('June');}
      case 7: {return translate('July');}
      case 8: {return translate('August');}
      case 9: {return translate('September');}
      case 10: {return translate('October');}
      case 11: {return translate('November');}
      case 12: {return translate('December');}
    }
  }

  String? getMiladiMonthAbbreviations(int monthNumber){
    switch(monthNumber){
      case 1: {return 'Jan';}
      case 2: {return 'Feb';}
      case 3: {return 'Mar';}
      case 4: {return 'Apr';}
      case 5: {return 'May';}
      case 6: {return 'Jun';}
      case 7: {return 'Jul';}
      case 8: {return 'Aug';}
      case 9: {return 'Sept';}
      case 10: {return 'Oct';}
      case 11: {return 'Nov';}
      case 12: {return 'Dec';}
    }
  }
}



