import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/AthanPlayer.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/SliderWidget.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';
import 'package:sally_prayer_times/main.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget{
  SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..backgroundColor = Colors.white
      ..indicatorColor = Provider.of<ThemeProvider>(context, listen: false).appBarColor
      ..textColor = Provider.of<ThemeProvider>(context, listen: false).appBarColor
      ..dismissOnTap = true
      ..loadingStyle = EasyLoadingStyle.light;
  }

  void showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).appBarColor),),backgroundColor: Colors.white, padding: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0, top: 0.0),));
  }

  void locationHandler() async{
    EasyLoading.show(status: translate('loading'));

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        showSnackBar(translate('please_enable_GPS_location'));
        EasyLoading.dismiss(animation: true);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnackBar(translate('please_allow_the_app_to_get_your_location'));
        EasyLoading.dismiss(animation: true);
        return;
      }
    }

    _locationData = await location.getLocation().timeout(Duration(seconds: 10),onTimeout: (){
      showSnackBar(translate('try_moving_your_phone'));
      EasyLoading.dismiss(animation: true);
      return _locationData!;
    });

    if(_locationData == null){
      showSnackBar(translate('try_moving_your_phone'));
      EasyLoading.dismiss(animation: true);
      return;
    }

    Provider.of<SettingsProvider>(context, listen: false).longitude = _locationData.longitude.toString();
    Provider.of<SettingsProvider>(context, listen: false).latitude = _locationData.latitude.toString();

    Provider.of<SettingsProvider>(context, listen: false).LocationLongLat.clear();
    Provider.of<SettingsProvider>(context, listen: false).LocationLongLat = {'longitude': _locationData.longitude.toString(), 'latitude': _locationData.latitude.toString()};

    try{
      var placemarks = await Geocoder.placemarkFromCoordinates(_locationData.latitude!, _locationData.longitude!);
      Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country!;
      Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality! + ' ('+placemarks.first.street!+')';
    }catch(e){
      try{
        var placemarks = await Geocoder.placemarkFromCoordinates(_locationData.latitude!, _locationData.longitude!);
        Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country!;
        Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality! + ' ('+placemarks.first.street!+')';
      }catch(e){
        Provider.of<SettingsProvider>(context, listen: false).country = _locationData.longitude.toString();
        Provider.of<SettingsProvider>(context, listen: false).city = _locationData.latitude.toString();
      }
    }

    //calculate timezone
    try{
      int offsetInMillis = DateTime.now().timeZoneOffset.inMilliseconds;
      String offset = (offsetInMillis / 3600000).abs().toInt().toString() +'.'+ ((offsetInMillis / 60000) % 60).abs().toInt().toString();
      String timeZoneOffset = (offsetInMillis >= 0 ? "" : "-") + offset;
      double timeZone = double.parse(timeZoneOffset);
      Provider.of<SettingsProvider>(context, listen: false).timezone = timeZone.toString();
    }catch(e){}

    EasyLoading.dismiss(animation: true);
    showSnackBar(translate('location_saved')+': ' + Provider.of<SettingsProvider>(context, listen: false).country +' / '+ Provider.of<SettingsProvider>(context, listen: false).city);
  }

  void calculationMethodHandler() async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: translate(Configuration.UmmAlQuraUnivKey), key: 11),
      AlertDialogAction(label: translate(Configuration.EgytionGeneralAuthorityofSurveyKey), key: 12),
      AlertDialogAction(label: translate(Configuration.UnivOfIslamicScincesKarachiKey), key: 13),
      AlertDialogAction(label: translate(Configuration.IslamicSocietyOfNorthAmericaKey), key: 14),
      AlertDialogAction(label: translate(Configuration.MuslimWorldLeagueKey), key: 15),
      AlertDialogAction(label: translate(Configuration.FederationofIslamicOrganizationsinFranceKey), key: 16),
      AlertDialogAction(label: translate(Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey), key: 17),
      AlertDialogAction(label: translate(Configuration.InstituteOfGeophysicsUniversityOfTehranKey), key: 18),
      AlertDialogAction(label: translate(Configuration.ShiaIthnaAshariLevaInstituteQumKey), key: 19),
      AlertDialogAction(label: translate(Configuration.GulfRegionKey), key: 20),
      AlertDialogAction(label: translate(Configuration.QatarKey), key: 21),
      AlertDialogAction(label: translate(Configuration.MajlisUgamaIslamSingapuraSingaporeKey), key: 22),
      AlertDialogAction(label: translate(Configuration.DirectorateOfReligiousAffairsTurkeyKey), key: 23),
      AlertDialogAction(label: translate(Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey), key: 24),
      AlertDialogAction(label: translate(Configuration.TheGrandeMosqueedeParis), key: 25),
      AlertDialogAction(label: translate(Configuration.AlgerianMinisterofReligiousAffairsandWakfs), key: 26),
      AlertDialogAction(label: translate(Configuration.JabatanKemajuanIslamMalaysia), key: 27),
      AlertDialogAction(label: translate(Configuration.TunisianMinistryofReligiousAffairs), key: 28),
      AlertDialogAction(label: translate(Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments), key: 29),
    ];
    var calculationMethod = await showConfirmationDialog(context: context, title: translate('calculation_method'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(calculationMethod != null){
      switch(calculationMethod){
        case 11: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UmmAlQuraUnivKey;} break;
        case 12: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.EgytionGeneralAuthorityofSurveyKey;} break;
        case 13: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UnivOfIslamicScincesKarachiKey;} break;
        case 14: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.IslamicSocietyOfNorthAmericaKey;} break;
        case 15: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.MuslimWorldLeagueKey;} break;
        case 16: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.FederationofIslamicOrganizationsinFranceKey;} break;
        case 17: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey;} break;
        case 18: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.InstituteOfGeophysicsUniversityOfTehranKey;} break;
        case 19: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.ShiaIthnaAshariLevaInstituteQumKey;} break;
        case 20: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.GulfRegionKey;} break;
        case 21: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.QatarKey;} break;
        case 22: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.MajlisUgamaIslamSingapuraSingaporeKey;} break;
        case 23: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.DirectorateOfReligiousAffairsTurkeyKey;} break;
        case 24: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey;} break;
        case 25: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TheGrandeMosqueedeParis;} break;
        case 26: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.AlgerianMinisterofReligiousAffairsandWakfs;} break;
        case 27: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.JabatanKemajuanIslamMalaysia;} break;
        case 28: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TunisianMinistryofReligiousAffairs;} break;
        case 29: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments;} break;
        default: {Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.MuslimWorldLeagueKey;} break;
      }
      showSnackBar(translate('saved_successfully') +' : '+ translate('calculation_method'));
    }
  }

  void timeZoneHandler() async{
    try{
      int offsetInMillis = DateTime.now().timeZoneOffset.inMilliseconds;
      String offset = (offsetInMillis / 3600000).abs().toInt().toString() +'.'+ ((offsetInMillis / 60000) % 60).abs().toInt().toString();
      String timeZoneOffset = (offsetInMillis >= 0 ? "" : "-") + offset;
      double timeZone = double.parse(timeZoneOffset);
      Provider.of<SettingsProvider>(context, listen: false).timezone = timeZone.toString();
    }catch(e){}
    List<DialogTextField> textFields = [
      DialogTextField(initialText: Provider.of<SettingsProvider>(context, listen: false).timezone.toString()),
    ];
    var timeZone = await showTextInputDialog(context: context, title: translate('Time_Zone'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), message: translate('time_zone_message'), textFields: textFields);
    if(timeZone != null){
      try{
        double finalTimeZone = double.parse(timeZone.first.replaceAll(':', '.'));
        Provider.of<SettingsProvider>(context, listen: false).timezone = finalTimeZone.toString();
        showSnackBar(translate('saved_successfully') +' : '+ translate('Time_Zone'));
      }catch(e){
        showSnackBar(translate('Time_Zone')+' '+translate('is_NOT_valid'));
      }
    }
  }

  void madhabHandler() async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: translate(Configuration.shafiiKey), key: 31),
      AlertDialogAction(label: translate(Configuration.hanafiKey), key: 32),
    ];
    var madhabType = await showConfirmationDialog(context: context, title: translate('Madhab'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(madhabType != null){
      switch(madhabType){
        case 31: {Provider.of<SettingsProvider>(context, listen: false).madhab = Configuration.shafiiKey;} break;
        case 32: {Provider.of<SettingsProvider>(context, listen: false).madhab = Configuration.hanafiKey;} break;
        default: {Provider.of<SettingsProvider>(context, listen: false).madhab = Configuration.shafiiKey;} break;
      }
      showSnackBar(translate('saved_successfully') +' : '+ translate('Madhab'));
    }
  }

  void typeTimeHandler() async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: translate(Configuration.standardKey), key: 41),
      AlertDialogAction(label: translate(Configuration.summeryKey), key: 42),
    ];
    var standardOrSummey = await showConfirmationDialog(context: context, title: translate('Time_type'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(standardOrSummey != null){
      switch(standardOrSummey){
        case 41: {Provider.of<SettingsProvider>(context, listen: false).typeTime = Configuration.standardKey;} break;
        case 42: {Provider.of<SettingsProvider>(context, listen: false).typeTime = Configuration.summeryKey;} break;
        default: {Provider.of<SettingsProvider>(context, listen: false).typeTime = Configuration.standardKey;} break;
      }
      showSnackBar(translate('saved_successfully') +' : '+ translate('Time_type'));
    }
  }

  void hijriTimeAdjustment() async{
    var value = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SliderWidget(title: translate(translate('Hijri_Time_Adjustment')),min: -10, max: 10, divisions: 20, defaultValue: double.tryParse(Provider.of<SettingsProvider>(context, listen: false).hijriAdjustment));
        });
    if(value != null){
      try{
        int? hijriAdjustment = value.toInt();
        Provider.of<SettingsProvider>(context, listen: false).hijriAdjustment = hijriAdjustment.toString();
        showSnackBar(translate('saved_successfully') +' : '+ translate('Hijri_Time_Adjustment'));
      }catch(e){
        showSnackBar(translate('Hijri_Time_Adjustment')+' '+translate('is_NOT_valid'));
      }
    }
  }

  void time12_24Handler() async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: Configuration.time12or24_24, key: 51),
      AlertDialogAction(label: Configuration.time12or24_12, key: 52),
    ];
    var time12or24 = await showConfirmationDialog(context: context, title: '12h / 24H', okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(time12or24 != null){
      switch(time12or24){
        case 51: {Provider.of<SettingsProvider>(context, listen: false).time12_24 = Configuration.time12or24_24;} break;
        case 52: {Provider.of<SettingsProvider>(context, listen: false).time12_24 = Configuration.time12or24_12;} break;
        default: {Provider.of<SettingsProvider>(context, listen: false).time12_24 = Configuration.time12or24_24;} break;
      }
      showSnackBar(translate('saved_successfully') +' : '+ '12h / 24H ');
    }
  }

  void athanHandler() async{
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(value: translate(Configuration.ali_ben_ahmed_mala_key), child: new Text(translate(Configuration.ali_ben_ahmed_mala_key)),),
      DropdownMenuItem(value: translate(Configuration.abd_el_basset_abd_essamad_key), child: new Text(translate(Configuration.ali_ben_ahmed_mala_key)),),
      DropdownMenuItem(value: translate(Configuration.farou9_abd_errehmane_hadraoui_key), child: new Text(translate(Configuration.farou9_abd_errehmane_hadraoui_key)),),
      DropdownMenuItem(value: translate(Configuration.mohammad_ali_el_banna_key), child: new Text(translate(Configuration.mohammad_ali_el_banna_key)),),
      DropdownMenuItem(value: translate(Configuration.mohammad_khalil_raml_key), child: new Text(translate(Configuration.mohammad_khalil_raml_key)),),
    ];
    var value = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AthanPlayer(title: translate('athan'), items: items);
        });
    if(value != null){
      if(value == translate(Configuration.abd_el_basset_abd_essamad_key)){
        Provider.of<SettingsProvider>(context, listen: false).athan = Configuration.abd_el_basset_abd_essamad_key;
      }else if(value == translate(Configuration.ali_ben_ahmed_mala_key)){
        Provider.of<SettingsProvider>(context, listen: false).athan = Configuration.ali_ben_ahmed_mala_key;
      }else if(value == translate(Configuration.farou9_abd_errehmane_hadraoui_key)){
        Provider.of<SettingsProvider>(context, listen: false).athan = Configuration.farou9_abd_errehmane_hadraoui_key;
      }else if(value == translate(Configuration.mohammad_ali_el_banna_key)){
        Provider.of<SettingsProvider>(context, listen: false).athan = Configuration.mohammad_ali_el_banna_key;
      }else if(value == translate(Configuration.mohammad_khalil_raml_key)){
        Provider.of<SettingsProvider>(context, listen: false).athan = Configuration.mohammad_khalil_raml_key;
      }
      showSnackBar(translate('saved_successfully') +' : '+ translate('athan'));
    }
  }

  void languageHandler() async{
    List<AlertDialogAction> actions = [
      AlertDialogAction(label: translate(Configuration.englisNamehKey), key: 71),
      AlertDialogAction(label: translate(Configuration.frenchNameKey), key: 72),
      AlertDialogAction(label: translate(Configuration.italianoNameKey), key: 73),
      AlertDialogAction(label: translate(Configuration.arabicNameKey), key: 74),
    ];
    var language = await showConfirmationDialog(context: context, title: translate('Language'), okLabel: translate('OK'), cancelLabel: translate('CANCEL'), actions: actions);
    if(language != null){
      switch(language){
        case 71: {Provider.of<SettingsProvider>(context, listen: false).language = Configuration.englishKey; changeLocale(context, Configuration.englishKey);} break;
        case 72: {Provider.of<SettingsProvider>(context, listen: false).language = Configuration.frenchKey; changeLocale(context, Configuration.frenchKey);} break;
        case 73: {Provider.of<SettingsProvider>(context, listen: false).language = Configuration.italianoKey; changeLocale(context, Configuration.italianoKey);} break;
        case 74: {Provider.of<SettingsProvider>(context, listen: false).language = Configuration.arabicKey; changeLocale(context, Configuration.arabicKey);} break;
        default: {Provider.of<SettingsProvider>(context, listen: false).language = Configuration.englishKey; changeLocale(context, Configuration.englishKey);} break;
      }
      showSnackBar(translate('saved_successfully') +' : '+ translate('Language'));
    }
  }

  void allTimesAdjustment(String prayerName, int prayerNumber) async{
    var value = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SliderWidget(title: prayerName+' '+translate('Time_Adjustment'),min: -60, max: 60, divisions: 120, defaultValue: 0,);
        });
    if(value != null){
      try{
        int? timeAdjustment = value.toInt();
        switch(prayerNumber){
          case 1: {Provider.of<SettingsProvider>(context, listen: false).fajrTimeAdjustment = timeAdjustment.toString();} break;
          case 2: {Provider.of<SettingsProvider>(context, listen: false).shoroukTimeAdjustment = timeAdjustment.toString();} break;
          case 3: {Provider.of<SettingsProvider>(context, listen: false).duhrTimeAdjustment = timeAdjustment.toString();} break;
          case 4: {Provider.of<SettingsProvider>(context, listen: false).asrTimeAdjustment = timeAdjustment.toString();} break;
          case 5: {Provider.of<SettingsProvider>(context, listen: false).maghribTimeAdjustment = timeAdjustment.toString();} break;
          case 6: {Provider.of<SettingsProvider>(context, listen: false).ishaaTimeAdjustment = timeAdjustment.toString();} break;
        }
        showSnackBar(translate('saved_successfully') +' : '+ prayerName +' : '+ translate('Time_Adjustment'));
      }catch(e){
        showSnackBar(prayerName + translate('Time_Adjustment')+' '+ translate('is_NOT_valid'));
      }
    }
  }

  bool isBatteryOptimized = PreferenceUtils.getBool(Configuration.IS_BATTERY_OPTIMIZED, false);
  ignoreBatteryOptimizationsHandler() async{
    if(isBatteryOptimized == false){
      var status = await PermissionHandler.Permission.ignoreBatteryOptimizations.status;
      if (status.isGranted == false) {
        bool isOptimised = await PermissionHandler.Permission.ignoreBatteryOptimizations.request().isGranted;
        if(isOptimised == true){
          PreferenceUtils.setBool(Configuration.IS_BATTERY_OPTIMIZED, isOptimised);
          setState(() {
            isBatteryOptimized = isOptimised;
          });
          showSnackBar(translate('the_app_is_excluded'));
        }else{
          showSnackBar(translate('please_allow_the_app_to_be_excluded'));
        }
      }else{
        showSnackBar(translate('please_allow_the_app_to_be_excluded'));
      }
    }else{
      showSnackBar(translate('the_app_is_already_excluded'));
    }
  }

  void donationHandler() async{
    await canLaunch('http://paypal.me/bibali1980') ? await launch('http://paypal.me/bibali1980') : showSnackBar(translate('please_try_again_later_or_donate_manually_here')+': https://sallyprayertimes.com');
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Provider.of<ThemeProvider>(context, listen: true).appBarColor;
    return Scaffold(
      body: SettingsList(
        sections: [
          CustomSection(child: Padding(padding: EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0)),),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Location'),
            tiles: [
              SettingsTile(
                title: translate('Location'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).country + ' / ' +Provider.of<SettingsProvider>(context, listen: true).city,
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {locationHandler();},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Time'),
            tiles: [
              SettingsTile(
                title: translate('calculation_method'),
                subtitle: translate(Provider.of<SettingsProvider>(context, listen: true).calculationMethod),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {calculationMethodHandler();},
              ),
              SettingsTile(
                title: translate('Time_Zone'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).timezone.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {timeZoneHandler();},
              ),
              SettingsTile(
                title: translate('Madhab'),
                subtitle: translate(Provider.of<SettingsProvider>(context, listen: false).madhab),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {madhabHandler();},
              ),
              SettingsTile(
                title: translate('Time_type'),
                subtitle: translate(Provider.of<SettingsProvider>(context, listen: true).typeTime),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {typeTimeHandler();},
              ),
              SettingsTile(
                title: translate('Hijri_Time_Adjustment'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).hijriAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {hijriTimeAdjustment();},
              ),
              SettingsTile(
                title: '12h / 24H',
                subtitle: Provider.of<SettingsProvider>(context, listen: true).time12_24,
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {time12_24Handler();},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('athan'),
            tiles: [
              SettingsTile(
                title: translate('athan'),
                subtitle: translate(Provider.of<SettingsProvider>(context, listen: true).athan),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {athanHandler();},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Language'),
            tiles: [
              SettingsTile(
                title: translate('Language'),
                subtitle: translate(getLanguage(Provider.of<SettingsProvider>(context, listen: true).language)),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {languageHandler();},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Time_Adjustment'),
            tiles: [
              SettingsTile(
                title: translate('fajr'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).fajrTimeAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('fajr'), 1);},
              ),
              SettingsTile(
                title: translate('shorouk'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).shoroukTimeAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('shorouk'), 2);},
              ),
              SettingsTile(
                title: translate('duhr'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).duhrTimeAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('duhr'), 3);},
              ),
              SettingsTile(
                title: translate('asr'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).asrTimeAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('asr'), 4);},
              ),
              SettingsTile(
                title: translate('maghrib'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).maghribTimeAdjustment.toString(),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('maghrib'), 5);},
              ),
              SettingsTile(
                title: translate('ishaa'),
                subtitle: Provider.of<SettingsProvider>(context, listen: true).ishaaTimeAdjustment.toString()
                ,
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {allTimesAdjustment(translate('ishaa'), 6);},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Battery'),
            tiles: [
              SettingsTile.switchTile(
                title: translate('Battery_Optimization'),
                subtitle: translate('please_allow_the_app_to_be_excluded'),
                onToggle: (bool value) {ignoreBatteryOptimizationsHandler();},
                switchValue: isBatteryOptimized,
                subtitleMaxLines: 100,
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Theme_Colors'),
            tiles: [
              SettingsTile(
                title: translate('App_Bar_Color'),
                leading: Icon(Icons.color_lens, color: appBarColor,),
                onPressed: (BuildContext context) {
                  showColorPicker(Provider.of<ThemeProvider>(context, listen: false).appBarColor, 'appbar');
                },
              ),
              SettingsTile(
                title: translate('Prayers_Times_Color'),
                leading: Icon(Icons.color_lens, color: Provider.of<ThemeProvider>(context, listen: true).prayersColor,),
                onPressed: (BuildContext context) {
                  showColorPicker(Provider.of<ThemeProvider>(context, listen: false).prayersColor, 'prayers');
                },
              ),
              SettingsTile(
                title: translate('Next_Prayer_Time_Color'),
                leading: Icon(Icons.color_lens, color: Provider.of<ThemeProvider>(context, listen: true).nextPrayerColor,),
                onPressed: (BuildContext context) {
                  showColorPicker(Provider.of<ThemeProvider>(context, listen: false).nextPrayerColor, 'next_prayer_color');
                },
              ),
              SettingsTile(
                title: translate('Bottom_Navigation_Bar_Color'),
                leading: Icon(Icons.color_lens, color: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,),
                onPressed: (BuildContext context) {
                  showColorPicker(Provider.of<ThemeProvider>(context, listen: false).navigationBarColor, 'navigation_bar');
                },
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Widget_Colors'),
            tiles: [
              SettingsTile(
                title: translate('Widget_Background_Color'),
                leading: Icon(Icons.color_lens, color: Provider.of<ThemeProvider>(context, listen: true).widgetBackgroundColor,),
                onPressed: (BuildContext context) {
                  showColorPicker(Provider.of<ThemeProvider>(context, listen: false).widgetBackgroundColor, 'widget_background');
                },
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('darkMode'),
            tiles: [
              SettingsTile.switchTile(
                title: translate('darkMode'),
                onToggle: (bool value) {
                  AdaptiveTheme.of(context).toggleThemeMode();
                },
                switchValue: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? true : false,
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: appBarColor, fontWeight: FontWeight.bold),
            title: translate('Donation'),
            tiles: [
              SettingsTile(
                title: translate('Donation'),
                leading: Icon(Icons.favorite, color: Colors.pink),
                subtitle: translate('donation_message'),
                subtitleMaxLines: 100,
                onPressed: (BuildContext context) {donationHandler();},
              ),
            ],
          ),
          CustomSection(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 30.0),
              ),
          ),
        ],
      ),
    );
  }

  Future<void> showColorPicker(Color currentColor, String property){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('Select_a_color')),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color){
                switch(property) {
                  case 'appbar': {Provider.of<ThemeProvider>(context, listen: false).appBarColor = color;}break;
                  case 'prayers': {Provider.of<ThemeProvider>(context, listen: false).prayersColor = color;}break;
                  case 'navigation_bar': {Provider.of<ThemeProvider>(context, listen: false).navigationBarColor = color;AdaptiveTheme.of(context).toggleThemeMode();AdaptiveTheme.of(context).toggleThemeMode();}break;
                  case 'next_prayer_color': {Provider.of<ThemeProvider>(context, listen: false).nextPrayerColor = color;}break;
                  case 'widget_background': {Provider.of<ThemeProvider>(context, listen: false).widgetBackgroundColor = color;}break;
                }
                setState(() {
                  currentColor = color;
                });
              },
            ),
          ),
        );
      },
    );
  }

  String getLanguage(String language){
    switch(language){
      case Configuration.englishKey: return Configuration.englisNamehKey; break;
      case Configuration.frenchKey: return Configuration.frenchNameKey; break;
      case Configuration.italianoKey: return Configuration.italianoNameKey; break;
      case Configuration.arabicKey: return Configuration.arabicNameKey; break;
      default: return Configuration.englisNamehKey; break;
    }
  }
}