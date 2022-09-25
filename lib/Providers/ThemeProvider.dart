import 'package:flutter/material.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Prayer/AthanServiceManager.dart';
import 'PrayersProvider.dart';

class ThemeProvider with ChangeNotifier {

  static final ThemeProvider _ThemeProvider = new ThemeProvider._internal();
  factory ThemeProvider() {
    return _ThemeProvider;
  }
  ThemeProvider._internal();

  Color _appBarColor = Color(PreferenceUtils.getInt(Configuration.APP_BAR_COLOR, Colors.blue.shade800.value));
  Color get appBarColor{
    return _appBarColor;
  }
  set appBarColor(Color value) {
    PreferenceUtils.setInt(Configuration.APP_BAR_COLOR, value.value);
    _appBarColor = value;
    notifyListeners();
  }

  Color _navigationBarColor = Color(PreferenceUtils.getInt(Configuration.NAVIGATION_BAR_COLOR, Colors.blue.shade800.value));
  Color get navigationBarColor{
    return _navigationBarColor;
  }
  set navigationBarColor(Color value) {
    PreferenceUtils.setInt(Configuration.NAVIGATION_BAR_COLOR, value.value);
    _navigationBarColor = value;
    notifyListeners();
  }

  Color _prayersColor = Color(PreferenceUtils.getInt(Configuration.PRAYERS_COLOR, Colors.blueGrey.value));
  Color get prayersColor{
    return _prayersColor;
  }
  set prayersColor(Color value) {
    PreferenceUtils.setInt(Configuration.PRAYERS_COLOR, value.value);
    _prayersColor = value;
    refreshColors();
    notifyListeners();
  }

  Color _nextPrayerColor = Color(PreferenceUtils.getInt(Configuration.NEXT_PRAYER_COLOR, Colors.deepOrange.value));
  Color get nextPrayerColor{
    return _nextPrayerColor;
  }
  set nextPrayerColor(Color value) {
    PreferenceUtils.setInt(Configuration.NEXT_PRAYER_COLOR, value.value);
    _nextPrayerColor = value;
    refreshColors();
    notifyListeners();
  }

  static Color hexFromRgbString(String argbColor) {
    List myColor = argbColor.split(':');
    return Color.fromARGB(int.parse(myColor[0]), int.parse(myColor[1]), int.parse(myColor[2]), int.parse(myColor[3]));
  }

  Color _widgetBackgroundColor = hexFromRgbString(PreferenceUtils.getString(Configuration.WIDGET_BACKGROUND_COLOR, '255:0:64:255'));
  Color get widgetBackgroundColor{
    return _widgetBackgroundColor;
  }
  set widgetBackgroundColor(Color value) {
    PreferenceUtils.setString(Configuration.WIDGET_BACKGROUND_COLOR, value.alpha.toString()+':'+value.red.toString()+':'+value.green.toString()+':'+value.blue.toString());
    _widgetBackgroundColor = value;
    notifyListeners();
    AthanServiceManager.startService();
  }

  Color _fajrPrayerColor = Colors.blueGrey;
  Color get fajrPrayerColor{
    return _fajrPrayerColor;
  }
  set fajrPrayerColor(Color value) {
    _fajrPrayerColor = value;
    notifyListeners();
  }

  Color _shoroukPrayerColor = Colors.blueGrey;
  Color get shoroukPrayerColor{
    return _shoroukPrayerColor;
  }
  set shoroukPrayerColor(Color value) {
    _shoroukPrayerColor = value;
    notifyListeners();
  }

  Color _duhrPrayerColor = Colors.blueGrey;
  Color get duhrPrayerColor{
    return _duhrPrayerColor;
  }
  set duhrPrayerColor(Color value) {
    _duhrPrayerColor = value;
    notifyListeners();
  }

  Color _asrPrayerColor = Colors.blueGrey;
  Color get asrPrayerColor{
    return _asrPrayerColor;
  }
  set asrPrayerColor(Color value) {
    _asrPrayerColor = value;
    notifyListeners();
  }

  Color _maghribPrayerColor = Colors.blueGrey;
  Color get maghribPrayerColor{
    return _maghribPrayerColor;
  }
  set maghribPrayerColor(Color value) {
    _maghribPrayerColor = value;
    notifyListeners();
  }

  Color _ishaaPrayerColor = Colors.blueGrey;
  Color get ishaaPrayerColor{
    return _ishaaPrayerColor;
  }
  set ishaaPrayerColor(Color value) {
    _ishaaPrayerColor = value;
    notifyListeners();
  }

  void refreshColors(){
    fajrPrayerColor = prayersColor;
    shoroukPrayerColor = prayersColor;
    duhrPrayerColor = prayersColor;
    asrPrayerColor = prayersColor;
    maghribPrayerColor = prayersColor;
    ishaaPrayerColor = prayersColor;

    switch(PrayersProvider().nextPrayerTimeCode){
      case 0: {fajrPrayerColor = nextPrayerColor;} break;
      case 1: {shoroukPrayerColor = nextPrayerColor;} break;
      case 2: {duhrPrayerColor = nextPrayerColor;} break;
      case 3: {asrPrayerColor = nextPrayerColor;} break;
      case 4: {maghribPrayerColor = nextPrayerColor;} break;
      case 5: {ishaaPrayerColor = nextPrayerColor;} break;
    }
  }

}