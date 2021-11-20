import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  var delegate = await LocalizationDelegate.create(basePath: 'assets/languages',fallbackLocale: Configuration.englishKey, preferences: TranslatePreferences() ,supportedLocales: [Configuration.englishKey, Configuration.arabicKey, Configuration.frenchKey, Configuration.italianoKey ]);

  runApp(LocalizedApp(delegate, MyApp(savedThemeMode: savedThemeMode)));

  await AthanServiceManager.startService();
}

class MyApp extends StatelessWidget {

  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

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
  String _selectedLanguage = Configuration.englisNamehKey;
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
  String _selectedCalculationMethod = Configuration.MuslimWorldLeagueKey;
  String _calculationMethodMessage = '';

  bool isBatteryOptimized = PreferenceUtils.getBool(Configuration.IS_BATTERY_OPTIMIZED, false);
  ignoreBatteryOptimizationsHandler() async{
    if(isBatteryOptimized == false){
      var status = await PermissionHandler.Permission.ignoreBatteryOptimizations.status;
      if (status.isGranted == false) {
        bool isOptimised = await PermissionHandler.Permission.ignoreBatteryOptimizations.request().isGranted;
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

  void languageHandler(String language) async{
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

  refreshLanguageMessage(String language){
    setState(() {
      _languageMessage = translate('saved_successfully') +' : '+ translate(language)+' - '+translate('Language');
    });
  }

  void locationHandler() async{
    EasyLoading.show(status: translate('loading'));

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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
      return;
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
      var placemarks = await Geocoder.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
      Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country;
      Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality + ' ('+placemarks.first.street+')';
    }catch(e){
      try{
        var placemarks = await Geocoder.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
        Provider.of<SettingsProvider>(context, listen: false).country = placemarks.first.country;
        Provider.of<SettingsProvider>(context, listen: false).city = placemarks.first.locality + ' ('+placemarks.first.street+')';
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

  void calculationMethodHandler(String calculationMethod){
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
      _calculationMethodMessage = translate('saved_successfully') +' : '+ translate('calculation_method')+' - '+translate(calculationMethod);
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
                        child: new Text(translate(val)),
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
                  child: Text(_languageMessage, style: TextStyle(fontSize: 12, color: Colors.green),),
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
                  child: Text(translate('please_allow_the_app_to_be_excluded'), style: TextStyle(fontSize: 12, color: Colors.red),),
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
                  child: Text(_batteryOptimizationMessage, style: TextStyle(fontSize: 12, color: Colors.green),),
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
                  child: Text(translate('please_allow_the_app_to_get_your_location'), style: TextStyle(fontSize: 12, color: Colors.red),),
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
                  child: Text(_locationMessage, style: TextStyle(fontSize: 12, color: Colors.green),),
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
                  child: Text(_calculationMethodMessage, style: TextStyle(fontSize: 12, color: Colors.green),),
                ),
              ],
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
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
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: FancyBottomNavigation(
            circleColor: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
            inactiveIconColor: Provider.of<ThemeProvider>(context, listen: true).navigationBarColor,
            tabs: [
            TabData(
                iconData: FontAwesome5.pray,
                title: translate('prayers'),
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PrayersPage()))),
            TabData(
                iconData: Typicons.compass,
                title: translate('qibla'),
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => QiblaPage()))),
            TabData(
                iconData: Icons.settings,
                title: translate('settings'),
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SettingsPage()))),
            TabData(
                iconData: Icons.info,
                title: translate('info'),
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => InfoPage()))),
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return PrayersPage();
      case 1:
        return QiblaPage();
      case 2:
        return SettingsPage();
      case 3:
        return InfoPage();
    default:
        return PrayersPage();
    }
  }
}
