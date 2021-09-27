import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Prayer/AthanServiceManager.dart';

class PrayersProvider with ChangeNotifier {

  static final PrayersProvider _PrayersProvider = new PrayersProvider._internal();
  factory PrayersProvider() {
    return _PrayersProvider;
  }
  PrayersProvider._internal();

  int _nextPrayerTimeCode = 0;
  int get nextPrayerTimeCode{
    return _nextPrayerTimeCode;
  }
  set nextPrayerTimeCode(int value) {
    _nextPrayerTimeCode = value;
    notifyListeners();
  }

  int _fajrTimeInMinutes = 0;
  int get fajrTimeInMinutes{
    return _fajrTimeInMinutes;
  }
  set fajrTimeInMinutes(int value) {
    _fajrTimeInMinutes = value;
    notifyListeners();
  }

  int _shoroukTimeInMinutes = 0;
  int get shoroukTimeInMinutes{
    return _shoroukTimeInMinutes;
  }
  set shoroukTimeInMinutes(int value) {
    _shoroukTimeInMinutes = value;
    notifyListeners();
  }

  int _duhrTimeInMinutes = 0;
  int get duhrTimeInMinutes{
    return _duhrTimeInMinutes;
  }
  set duhrTimeInMinutes(int value) {
    _duhrTimeInMinutes = value;
    notifyListeners();
  }

  int _asrTimeInMinutes = 0;
  int get asrTimeInMinutes{
    return _asrTimeInMinutes;
  }
  set asrTimeInMinutes(int value) {
    _asrTimeInMinutes = value;
    notifyListeners();
  }

  int _maghribTimeInMinutes = 0;
  int get maghribTimeInMinutes{
    return _maghribTimeInMinutes;
  }
  set maghribTimeInMinutes(int value) {
    _maghribTimeInMinutes = value;
    notifyListeners();
  }

  int _ishaaTimeInMinutes = 0;
  int get ishaaTimeInMinutes{
    return _ishaaTimeInMinutes;
  }
  set ishaaTimeInMinutes(int value) {
    _ishaaTimeInMinutes = value;
    notifyListeners();
  }

  String _fajrTime = '00:00';
  String get fajrTime{
    return _fajrTime;
  }
  set fajrTime(String value) {
    _fajrTime = value;
    notifyListeners();
  }

  String _shoroukTime = '00:00';
  String get shoroukTime{
    return _shoroukTime;
  }
  set shoroukTime(String value) {
    _shoroukTime = value;
    notifyListeners();
  }

  String _duhrTime = '00:00';
  String get duhrTime{
    return _duhrTime;
  }
  set duhrTime(String value) {
    _duhrTime = value;
    notifyListeners();
  }

  String _asrTime = '00:00';
  String get asrTime{
    return _asrTime;
  }
  set asrTime(String value) {
    _asrTime = value;
    notifyListeners();
  }

  String _maghribTime = '00:00';
  String get maghribTime{
    return _maghribTime;
  }
  set maghribTime(String value) {
    _maghribTime = value;
    notifyListeners();
  }

  String _ishaaTime = '00:00';
  String get ishaaTime{
    return _ishaaTime;
  }
  set ishaaTime(String value) {
    _ishaaTime = value;
    notifyListeners();
  }

  String _nextPrayerName = '-----';
  String get nextPrayerName{
    return _nextPrayerName;
  }
  set nextPrayerName(String value) {
    _nextPrayerName = value;
    notifyListeners();
  }

  String _nextPrayerTime = '00:00';
  String get nextPrayerTime{
    return _nextPrayerTime;
  }
  set nextPrayerTime(String value) {
    _nextPrayerTime = value;
    notifyListeners();
  }

  String _fajrAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_FAJR_ATHAN_TYPE, Configuration.athanKey);
  String get fajrAthanType{
    return _fajrAthanType;
  }
  set fajrAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_FAJR_ATHAN_TYPE, value);
    _fajrAthanType = value;
    switch(value){
      case Configuration.athanKey: {fajrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {fajrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {fajrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {fajrPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _fajrPrayerIcon = Icons.volume_up;
  IconData get fajrPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_FAJR_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_fajrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_fajrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_fajrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_fajrPrayerIcon = Icons.volume_off;} break;
    }
    return _fajrPrayerIcon;
  }
  set fajrPrayerIcon(IconData value) {
    _fajrPrayerIcon = value;
    notifyListeners();
  }

  String _shoroukAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_SHOROUK_ATHAN_TYPE, Configuration.athanKey);
  String get shoroukAthanType{
    return _shoroukAthanType;
  }
  set shoroukAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_SHOROUK_ATHAN_TYPE, value);
    _shoroukAthanType = value;
    switch(value){
      case Configuration.athanKey: {shoroukPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {shoroukPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {shoroukPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {shoroukPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _shoroukPrayerIcon = Icons.volume_up;
  IconData get shoroukPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_SHOROUK_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_shoroukPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_shoroukPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_shoroukPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_shoroukPrayerIcon = Icons.volume_off;} break;
    }
    return _shoroukPrayerIcon;
  }
  set shoroukPrayerIcon(IconData value) {
    _shoroukPrayerIcon = value;
    notifyListeners();
  }

  String _duhrAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_DUHR_ATHAN_TYPE, Configuration.athanKey);
  String get duhrAthanType{
    return _duhrAthanType;
  }
  set duhrAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_DUHR_ATHAN_TYPE, value);
    _duhrAthanType = value;
    switch(value){
      case Configuration.athanKey: {duhrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {duhrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {duhrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {duhrPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _duhrPrayerIcon = Icons.volume_up;
  IconData get duhrPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_DUHR_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_duhrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_duhrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_duhrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_duhrPrayerIcon = Icons.volume_off;} break;
    }
    return _duhrPrayerIcon;
  }
  set duhrPrayerIcon(IconData value) {
    _duhrPrayerIcon = value;
    notifyListeners();
  }

  String _asrAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ASR_ATHAN_TYPE, Configuration.athanKey);
  String get asrAthanType{
    return _asrAthanType;
  }
  set asrAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_ASR_ATHAN_TYPE, value);
    _asrAthanType = value;
    switch(value){
      case Configuration.athanKey: {asrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {asrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {asrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {asrPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _asrPrayerIcon = Icons.volume_up;
  IconData get asrPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ASR_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_asrPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_asrPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_asrPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_asrPrayerIcon = Icons.volume_off;} break;
    }
    return _asrPrayerIcon;
  }
  set asrPrayerIcon(IconData value) {
    _asrPrayerIcon = value;
    notifyListeners();
  }

  String _maghribAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_MAGHRIB_ATHAN_TYPE, Configuration.athanKey);
  String get maghribAthanType{
    return _maghribAthanType;
  }
  set maghribAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_MAGHRIB_ATHAN_TYPE, value);
    _maghribAthanType = value;
    switch(value){
      case Configuration.athanKey: {maghribPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {maghribPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {maghribPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {maghribPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _maghribPrayerIcon = Icons.volume_up;
  IconData get maghribPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_MAGHRIB_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_maghribPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_maghribPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_maghribPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_maghribPrayerIcon = Icons.volume_off;} break;
    }
    return _maghribPrayerIcon;
  }
  set maghribPrayerIcon(IconData value) {
    _maghribPrayerIcon = value;
    notifyListeners();
  }

  String _ishaaAthanType = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ISHAA_ATHAN_TYPE, Configuration.athanKey);
  String get ishaaAthanType{
    return _ishaaAthanType;
  }
  set ishaaAthanType(String value) {
    PreferenceUtils.setString(Configuration.PRAYER_TIMES_ISHAA_ATHAN_TYPE, value);
    _ishaaAthanType = value;
    switch(value){
      case Configuration.athanKey: {ishaaPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {ishaaPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {ishaaPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {ishaaPrayerIcon = Icons.volume_off;} break;
    }
    notifyListeners();
  }
  IconData _ishaaPrayerIcon = Icons.volume_up;
  IconData get ishaaPrayerIcon{
    String value = PreferenceUtils.getString(Configuration.PRAYER_TIMES_ISHAA_ATHAN_TYPE, Configuration.athanKey);
    switch(value){
      case Configuration.athanKey: {_ishaaPrayerIcon = Icons.volume_up;} break;
      case Configuration.vibrationKey: {_ishaaPrayerIcon = Icons.vibration;} break;
      case Configuration.notificationKey: {_ishaaPrayerIcon = Icons.notifications_active;} break;
      case Configuration.nothingKey: {_ishaaPrayerIcon = Icons.volume_off;} break;
    }
    return _ishaaPrayerIcon;
  }
  set ishaaPrayerIcon(IconData value) {
    _ishaaPrayerIcon = value;
    notifyListeners();
  }



}