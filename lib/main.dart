import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_api_availability/google_api_availability.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Pages/CalendarPage.dart';
import 'package:sally_prayer_times/Pages/PrayersPage.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Pages/InfoPage.dart';
import 'package:sally_prayer_times/Pages/QiblaPage.dart';
import 'package:sally_prayer_times/Pages/SettingsPage.dart';
import 'package:sally_prayer_times/Prayer/AthanServiceManager.dart';
import 'package:sally_prayer_times/Providers/PrayersProvider.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';

import 'Classes/TranslatePreferences.dart';
import 'Huawei/HuaweiHelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HuaweiHelper.init();
  await PreferenceUtils.init();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  var delegate = await LocalizationDelegate.create(basePath: 'assets/languages',fallbackLocale: Configuration.englishKey, preferences: TranslatePreferences() ,supportedLocales: [Configuration.englishKey, Configuration.arabicKey, Configuration.frenchKey, Configuration.italianoKey ]);

  runApp(LocalizedApp(delegate, MyApp(savedThemeMode: savedThemeMode)));

  AthanServiceManager.startService();
}

class MyApp extends StatelessWidget {

  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
        ChangeNotifierProvider<PrayersProvider>(create: (_) => PrayersProvider()),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
            localizationDelegate
          ],
          debugShowCheckedModeBanner: false,
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          //theme: ThemeData(primaryColor: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,),
          theme: theme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: PreferenceUtils.getBool(Configuration.IS_FIRST_STARTUP, true) == true ? OnBoardingPage() : MyHomePage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

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

  List<String> _languages = [
    Configuration.englisNamehKey,
    Configuration.frenchNameKey,
    Configuration.italianoNameKey,
    Configuration.arabicNameKey,
  ];
  String? _selectedLanguage = Configuration.englisNamehKey;
  String _languageMessage = '';
  String _batteryOptimizationMessage = '';
  String _locationMessage = '';
  List<String> _calculationMethods = [
    Configuration.UmmAlQuraUnivKey,
    Configuration.EgytionGeneralAuthorityofSurveyKey,
    Configuration.UnivOfIslamicScincesKarachiKey,
    Configuration.IslamicSocietyOfNorthAmericaKey,
    Configuration.MuslimWorldLeagueKey,
    Configuration.FederationofIslamicOrganizationsinFranceKey,
    Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey,
    Configuration.InstituteOfGeophysicsUniversityOfTehranKey,
    Configuration.ShiaIthnaAshariLevaInstituteQumKey,
    Configuration.GulfRegionKey,
    Configuration.QatarKey,
    Configuration.MajlisUgamaIslamSingapuraSingaporeKey,
    Configuration.DirectorateOfReligiousAffairsTurkeyKey,
    Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey,
    Configuration.TheGrandeMosqueedeParis,
    Configuration.AlgerianMinisterofReligiousAffairsandWakfs,
    Configuration.JabatanKemajuanIslamMalaysia,
    Configuration.TunisianMinistryofReligiousAffairs,
    Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments,
  ];
  String? _selectedCalculationMethod = Configuration.MuslimWorldLeagueKey;
  String _calculationMethodMessage = '';

  bool isBatteryOptimized = PreferenceUtils.getBool(Configuration.IS_BATTERY_OPTIMIZED, false);
  ignoreBatteryOptimizationsHandler() async{
    if(isBatteryOptimized == false){
      var request = await PermissionHandler.Permission.ignoreBatteryOptimizations.request();
      bool isOptimised = await PermissionHandler.Permission.ignoreBatteryOptimizations.status.isGranted;
      if(isOptimised == true){
        PreferenceUtils.setBool(Configuration.IS_BATTERY_OPTIMIZED, isOptimised);
        isBatteryOptimized = isOptimised;
        setState(() {
          _batteryOptimizationMessage = translate('the_app_is_excluded');
        });
      }else{
        setState(() {
          _batteryOptimizationMessage = translate('please_allow_the_app_to_be_excluded');
        });
      }
    }
    else{
      setState(() {
        _batteryOptimizationMessage = translate('the_app_is_already_excluded');
      });
    }
  }

  void languageHandler(String? language) async{
    if(language == Configuration.englisNamehKey){
      Provider.of<SettingsProvider>(context, listen: false).language = Configuration.englishKey; changeLocale(context, Configuration.englishKey).then((value) =>
      {
        refreshLanguageMessage(language)
      });
    }else if(language == Configuration.frenchNameKey){
      Provider.of<SettingsProvider>(context, listen: false).language = Configuration.frenchKey; changeLocale(context, Configuration.frenchKey).then((value) =>
      {
        refreshLanguageMessage(language)
      });
    }
    else if(language == Configuration.italianoNameKey){
      Provider.of<SettingsProvider>(context, listen: false).language = Configuration.italianoKey; changeLocale(context, Configuration.italianoKey).then((value) =>
      {
        refreshLanguageMessage(language)
      });
    }
    else if(language == Configuration.arabicNameKey){
      Provider.of<SettingsProvider>(context, listen: false).language = Configuration.arabicKey; changeLocale(context, Configuration.arabicKey).then((value) =>
      {
        refreshLanguageMessage(language)
      });
    }
  }

  refreshLanguageMessage(String? language){
    setState(() {
      _languageMessage = translate('saved_successfully') +' : '+ translate(language!)+' - '+translate('Language');
    });
  }

  void locationHandler() async{
    if(HuaweiHelper.isHmsAviable){
      GooglePlayServicesAvailability googlePlayServicesAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
      if(googlePlayServicesAvailability == GooglePlayServicesAvailability.success){
        locationHandlerGoogle();
      }else{
        locationHandlerHuawei();
      }
    }else{
      locationHandlerGoogle();
    }
  }

  void locationHandlerHuawei() async{
    try {
      EasyLoading.show(status: translate('loading'));

      bool serviceEnabled;
      geolocator.LocationPermission permission;
      serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = translate('please_enable_GPS_location');
        });
        EasyLoading.dismiss(animation: true);
        return;
      }

      permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied || permission == geolocator.LocationPermission.deniedForever) {
          setState(() {
            _locationMessage = translate('please_allow_the_app_to_get_your_location');
          });
          EasyLoading.dismiss(animation: true);
          return;
        }
      }

      geolocator.Position? position =  await geolocator.Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 10),
        forceAndroidLocationManager: true,
        desiredAccuracy: geolocator.LocationAccuracy.medium,
      );

      if(position == null || position.longitude == 0 || position.latitude == 0){
        setState(() {
          _locationMessage = translate('try_moving_your_phone');
        });
        EasyLoading.dismiss(animation: true);
        return;
      }

      Provider.of<SettingsProvider>(context, listen: false).longitude = position.longitude.toString();
      Provider.of<SettingsProvider>(context, listen: false).latitude = position.latitude.toString();

      Provider.of<SettingsProvider>(context, listen: false).LocationLongLat.clear();
      Provider.of<SettingsProvider>(context, listen: false).LocationLongLat = {'longitude': position.longitude.toString(), 'latitude': position.latitude.toString()};

      try{
        var placemarks = await Geocoder.placemarkFromCoordinates(position.latitude, position.longitude);
        Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country!;
        Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality! + ' ('+placemarks.first.street!+')';
      }catch(e){
        try{
          var placemarks = await Geocoder.placemarkFromCoordinates(position.latitude, position.longitude);
          Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country!;
          Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality! + ' ('+placemarks.first.street!+')';
        }catch(e){
          Provider.of<SettingsProvider>(context, listen: false).country = position.longitude.toString();
          Provider.of<SettingsProvider>(context, listen: false).city = position.latitude.toString();
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
      setState(() {
        _locationMessage = translate('location_saved')+': ' + Provider.of<SettingsProvider>(context, listen: false).country +' / '+ Provider.of<SettingsProvider>(context, listen: false).city;
      });

    } catch (e) {
      EasyLoading.dismiss(animation: true);
    }
  }

  void locationHandlerGoogle() async{
    EasyLoading.show(status: translate('loading'));

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _locationMessage = translate('please_enable_GPS_location');
        });
        EasyLoading.dismiss(animation: true);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          _locationMessage = translate('please_allow_the_app_to_get_your_location');
        });
        EasyLoading.dismiss(animation: true);
        return;
      }
    }

    _locationData = await location.getLocation().timeout(Duration(seconds: 10),onTimeout: (){
      setState(() {
        _locationMessage = translate('try_moving_your_phone');
      });
      EasyLoading.dismiss(animation: true);
      return _locationData!;
    });

    if(_locationData == null){
      setState(() {
        _locationMessage = translate('try_moving_your_phone');
      });
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
    setState(() {
      _locationMessage = translate('location_saved')+': ' + Provider.of<SettingsProvider>(context, listen: false).country +' / '+ Provider.of<SettingsProvider>(context, listen: false).city;
    });
  }

  void _onIntroEnd(context) {
    PreferenceUtils.setBool(Configuration.IS_FIRST_STARTUP, false);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyHomePage()),
    );
  }

  void calculationMethodHandler(String? calculationMethod){
    if(calculationMethod == Configuration.UmmAlQuraUnivKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UmmAlQuraUnivKey;
    }else if(calculationMethod == Configuration.EgytionGeneralAuthorityofSurveyKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.EgytionGeneralAuthorityofSurveyKey;
    }else if(calculationMethod == Configuration.UnivOfIslamicScincesKarachiKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UnivOfIslamicScincesKarachiKey;
    }else if(calculationMethod == Configuration.IslamicSocietyOfNorthAmericaKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.IslamicSocietyOfNorthAmericaKey;
    }else if(calculationMethod == Configuration.MuslimWorldLeagueKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.MuslimWorldLeagueKey;
    }else if(calculationMethod == Configuration.FederationofIslamicOrganizationsinFranceKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.FederationofIslamicOrganizationsinFranceKey;
    }else if(calculationMethod == Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey;
    }else if(calculationMethod == Configuration.InstituteOfGeophysicsUniversityOfTehranKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.InstituteOfGeophysicsUniversityOfTehranKey;
    }else if(calculationMethod == Configuration.ShiaIthnaAshariLevaInstituteQumKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.ShiaIthnaAshariLevaInstituteQumKey;
    }else if(calculationMethod == Configuration.GulfRegionKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.GulfRegionKey;
    }else if(calculationMethod == Configuration.QatarKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.QatarKey;
    }else if(calculationMethod == Configuration.MajlisUgamaIslamSingapuraSingaporeKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.MajlisUgamaIslamSingapuraSingaporeKey;
    }else if(calculationMethod == Configuration.DirectorateOfReligiousAffairsTurkeyKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.DirectorateOfReligiousAffairsTurkeyKey;
    }else if(calculationMethod == Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey;
    }else if(calculationMethod == Configuration.TheGrandeMosqueedeParis){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TheGrandeMosqueedeParis;
    }else if(calculationMethod == Configuration.AlgerianMinisterofReligiousAffairsandWakfs){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.AlgerianMinisterofReligiousAffairsandWakfs;
    }else if(calculationMethod == Configuration.JabatanKemajuanIslamMalaysia){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.JabatanKemajuanIslamMalaysia;
    }else if(calculationMethod == Configuration.TunisianMinistryofReligiousAffairs){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.TunisianMinistryofReligiousAffairs;
    }else if(calculationMethod == Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments){
      Provider.of<SettingsProvider>(context, listen: false).calculationMethod = Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments;
    }

    setState(() {
      _calculationMethodMessage = translate('saved_successfully') +' : '+ translate('calculation_method')+' - '+translate(calculationMethod!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: '',
          image: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/intro_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 5,
          ),
          bodyWidget: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 50, right: 0, left: 0),
                  child: Text(translate('select_a_language'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                ),
                DropdownButton<String>(
                    value: _selectedLanguage,
                    items: _languages.map((String val) {
                      return new DropdownMenuItem<String>(
                        value: val,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: Image.asset(
                                val == Configuration.arabicNameKey ? "assets/flags/saudia_flag.png" :
                                val == Configuration.italianoNameKey ? "assets/flags/italy_flag.png" :
                                val == Configuration.frenchNameKey ? "assets/flags/france_flag.png" : "assets/flags/usa_flag.png" ,
                                width: 32, height: 32,),
                            ),
                            Text(translate(val)),
                          ],
                        ),
                      );
                    }).toList(),
                    hint: Text(translate('please_choose_a_language')),
                    onChanged: (newVal) {
                      languageHandler(newVal);
                      this.setState(() {
                        _selectedLanguage = newVal;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0),
                  child: Text(_languageMessage, style: TextStyle(fontSize: 14, color: Colors.green),),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          title: '',
          image: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/intro_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 5,
          ),
          bodyWidget: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20, right: 0, left: 0),
                  child: Text(translate('app_permission'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20, right: 0, left: 0),
                  child: Text(translate('please_allow_the_app_to_be_excluded'), style: TextStyle(fontSize: 14, color: Colors.red),),
                ),
                ElevatedButton(
                  onPressed: ignoreBatteryOptimizationsHandler,
                  child: Text(
                    translate('Battery_Optimization'),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0),
                  child: Text(_batteryOptimizationMessage, style: TextStyle(fontSize: 14, color: Colors.green),),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          title: '',
          image: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/intro_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 5,
          ),
          bodyWidget: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20, right: 0, left: 0),
                  child: Text(translate('Location_Option'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20, right: 0, left: 0),
                  child: Text(translate('please_allow_the_app_to_get_your_location'), style: TextStyle(fontSize: 14, color: Colors.red),),
                ),
                ElevatedButton(
                  onPressed: locationHandler,
                  child: Text(
                    translate('Find_Location'),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0),
                  child: Text(_locationMessage, style: TextStyle(fontSize: 14, color: Colors.green),),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          title: '',
          image: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/intro_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 5,
          ),
          bodyWidget: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 50, right: 0, left: 0),
                  child: Text(translate('Select_a_calculation_method'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20, right: 0, left: 0),
                  child: Text(translate('select_near_method_location'), style: TextStyle(fontSize: 14, color: Colors.red),),
                ),
                DropdownButton<String>(
                    isExpanded: true,
                    underline: Container(
                      height: 1,
                      color: Colors.transparent,
                    ),
                    value: _selectedCalculationMethod,
                    items: _calculationMethods.map((String val) {
                      return new DropdownMenuItem<String>(
                          value: val,
                          child: Container(
                            width:double.infinity,
                            alignment:Alignment.centerLeft,
                            child:Text(translate(val)),
                            decoration:BoxDecoration(
                                border:Border(bottom:BorderSide(color:Colors.grey,width:1))
                            ),
                          )
                      );
                    }).toList(),
                    hint: Text(translate('Please_choose_a_calculation_method'),overflow: TextOverflow.ellipsis,maxLines: 2,),
                    onChanged: (newVal) {
                      calculationMethodHandler(newVal);
                      this.setState(() {
                        _selectedCalculationMethod = newVal;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0),
                  child: Text(_calculationMethodMessage, style: TextStyle(fontSize: 14, color: Colors.green),),
                ),
              ],
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      //rtl: true, // Display as right-to-left
      skip: Text(translate('Skip'), style: TextStyle(color: Colors.white),),
      next: const Icon(Icons.arrow_forward, color: Colors.white,),
      done: Text(translate('Done'), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.indigo,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }


  List<Widget> _buildScreens() {
    return [
      PrayersPage(),
      CalendarPage(),
      QiblaPage(),
      SettingsPage(),
      //InfoPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(FontAwesome5.pray),
        title: translate('prayers'),
        activeColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
        inactiveColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FontAwesome.calendar),
        title: translate('calendar'),
        activeColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
        inactiveColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Typicons.compass),
        title: translate('qibla'),
        activeColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
        inactiveColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: translate('settings'),
        activeColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
        inactiveColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
      ),
    /*
      PersistentBottomNavBarItem(
        icon: Icon(Icons.info),
        title: translate('info'),
        activeColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
        inactiveColorPrimary: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
      ),
      */
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style14, // Choose the nav bar style with this property.
    );
  }

}
