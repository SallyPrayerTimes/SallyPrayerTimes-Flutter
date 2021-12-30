
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
}



