import 'dart:ui';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';

class TranslatePreferences implements ITranslatePreferences
{
  static const String _SELECTED_LOCAL_LANGUAGE_KEY = 'SELECTED_LOCAL_LANGUAGE_KEY';

  @override
  Future<Locale> getPreferredLocale() async
  {
    return localeFromString(PreferenceUtils.getString(_SELECTED_LOCAL_LANGUAGE_KEY, 'en'));
  }

  @override
  Future savePreferredLocale(Locale locale) async
  {
    PreferenceUtils.setString(_SELECTED_LOCAL_LANGUAGE_KEY, localeToString(locale));
  }
}