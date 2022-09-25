import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Prayer/AthanServiceManager.dart';
import 'package:sally_prayer_times/Prayer/HijriMiladiTimes.dart';

class SettingsProvider with ChangeNotifier {

  static final SettingsProvider _SettingsProvider = new SettingsProvider._internal();
  factory SettingsProvider() {
    return _SettingsProvider;
  }
  SettingsProvider._internal();

  String _country = PreferenceUtils.getString(Configuration.PRAYER_TIMES_COUNTRY, 'Saudi Arabia');
  String get country{
    return _country;
  }
  set country(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_COUNTRY, value);
    _country = value;
    notifyListeners();
  }

  String _city = PreferenceUtils.getString(Configuration.PRAYER_TIMES_CITY, 'Makkah');
  String get city{
    return _city;
  }
  set city(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_CITY, value);
    _city = value;
    notifyListeners();
  }

  Map<String, String> _LocationLongLat = {'longitude': '39.8409', 'latitude': '21.4309'};
  Map<String, String> get LocationLongLat{
    return _LocationLongLat;
  }
  set LocationLongLat(Map<String, String> value){
    _LocationLongLat = value;
    longitude = value['longitude']!;
    latitude = value['latitude']!;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _longitude = PreferenceUtils.getString(Configuration.PRAYER_TIMES_LONGITUDE, '39.8409');
  String get longitude{
    return _longitude;
  }
  set longitude(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_LONGITUDE, value);
    _longitude = value;
    notifyListeners();
  }

  String _latitude = PreferenceUtils.getString(Configuration.PRAYER_TIMES_LATITUDE, '21.4309');
  String get latitude{
    return _latitude;
  }
  set latitude(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_LATITUDE, value);
    _latitude = value;
    notifyListeners();
  }

  String _timezone = PreferenceUtils.getString(Configuration.PRAYER_TIMES_TIMEZONE, '3.0');
  String get timezone{
    return _timezone;
  }
  set timezone(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_TIMEZONE, value);
    _timezone = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _hijriAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, '0');
  String get hijriAdjustment{
    return _hijriAdjustment;
  }
  set hijriAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_HIJRI_ADJUSTMENT, value);
    _hijriAdjustment = value;
    notifyListeners();
    HijriTime().init();
  }

  int? _hijriDay = HijriTime().hijriDay;
  int? get hijriDay{
    _hijriDay = HijriTime().hijriDay;
    return _hijriDay;
  }
  set hijriDay(int? value) {
    _hijriDay = value;
    notifyListeners();
  }

  String? _hijriMonth = HijriTime().hijriMonth;
  String? get hijriMonth{
    _hijriMonth = HijriTime().hijriMonth;
    return _hijriMonth;
  }
  set hijriMonth(String? value) {
    _hijriMonth = value;
    notifyListeners();
  }

  int? _hijriYear = HijriTime().hijriYear;
  int? get hijriYear{
    _hijriYear = HijriTime().hijriYear;
    return _hijriYear;
  }
  set hijriYear(int? value) {
    _hijriYear = value;
    notifyListeners();
  }

  String _typeTime = PreferenceUtils.getString(Configuration.PRAYER_TIMES_TYPE_TIME, Configuration.standardKey);
  String get typeTime{
    return _typeTime;
  }
  set typeTime(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_TYPE_TIME, value);
    _typeTime = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _calendarType = PreferenceUtils.getString(Configuration.CALENDAR_TYPE, Configuration.CALENDAR_TYPE_MILADI);
  String get calendarType{
    return _calendarType;
  }
  set calendarType(String value) {
    PreferenceUtils.setString(Configuration.CALENDAR_TYPE, value);
    _calendarType = value;
    notifyListeners();
  }

  String _madhab = PreferenceUtils.getString(Configuration.PRAYER_TIMES_MADHAB, Configuration.shafiiKey);
  String get madhab{
    return _madhab;
  }
  set madhab(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_MADHAB, value);
    _madhab = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _calculationMethod = PreferenceUtils.getString(Configuration.PRAYER_TIMES_CALCULATION_METHOD, Configuration.MuslimWorldLeagueKey);
  String get calculationMethod{
    return _calculationMethod;
  }
  set calculationMethod(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_CALCULATION_METHOD, value);
    _calculationMethod = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _fajrTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_FAJR_TIME_ADJUSTMENT, '0');
  String get fajrTimeAdjustment{
    return _fajrTimeAdjustment;
  }
  set fajrTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_FAJR_TIME_ADJUSTMENT, value);
    _fajrTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _shoroukTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_SHOROUK_TIME_ADJUSTMENT, '0');
  String get shoroukTimeAdjustment{
    return _shoroukTimeAdjustment;
  }
  set shoroukTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_SHOROUK_TIME_ADJUSTMENT, value);
    _shoroukTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _duhrTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_DUHR_TIME_ADJUSTMENT, '0');
  String get duhrTimeAdjustment{
    return _duhrTimeAdjustment;
  }
  set duhrTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_DUHR_TIME_ADJUSTMENT, value);
    _duhrTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _asrTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ASR_TIME_ADJUSTMENT, '0');
  String get asrTimeAdjustment{
    return _asrTimeAdjustment;
  }
  set asrTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_ASR_TIME_ADJUSTMENT, value);
    _asrTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _maghribTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_MAGHRIB_TIME_ADJUSTMENT, '0');
  String get maghribTimeAdjustment{
    return _maghribTimeAdjustment;
  }
  set maghribTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_MAGHRIB_TIME_ADJUSTMENT, value);
    _maghribTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _ishaaTimeAdjustment = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ISHAA_TIME_ADJUSTMENT, '0');
  String get ishaaTimeAdjustment{
    return _ishaaTimeAdjustment;
  }
  set ishaaTimeAdjustment(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_ISHAA_TIME_ADJUSTMENT, value);
    _ishaaTimeAdjustment = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  String _language = PreferenceUtils.getString(Configuration.PRAYER_TIMES_LANGUAGE, Configuration.englishKey);
  String get language{
    return _language;
  }
  set language(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_LANGUAGE, value);
    _language = value;
    notifyListeners();
    AthanServiceManager.refreshWidget();
  }

  String _time12_24 = PreferenceUtils.getString(Configuration.PRAYER_TIMES_TIME_12_24, Configuration.time12or24_24);
  String get time12_24{
    return _time12_24;
  }
  set time12_24(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_TIME_12_24, value);
    _time12_24= value;
    notifyListeners();
    AthanServiceManager.getPrayerTimes();
    AthanServiceManager.refreshWidget();
  }

  String _athan = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ATHAN, Configuration.ali_ben_ahmed_mala_key);
  String get athan{
    return _athan;
  }
  set athan(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_ATHAN, value);
    _athan= value;
    notifyListeners();
  }


}