import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Classes/PreferenceUtils.dart';
import 'package:sally_prayer_times/Classes/QiblaDirectionCalculator.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:location/location.dart';

class QiblaPage extends StatefulWidget{
  QiblaPage({Key? key}) : super(key: key);
  @override
  _QiblaPage createState() => _QiblaPage();
}

class _QiblaPage extends State<QiblaPage>{

  double _qiblaDirection = QiblaDirectionCalculator.getQiblaDirectionFromNorth(double.parse(SettingsProvider().longitude), double.parse(SettingsProvider().latitude));

  String _qiblaErrorMessage = '';
  String _qiblaInfoMessage = translate('Location')+' : '+ SettingsProvider().country +' / '+ SettingsProvider().city;

  Image _compassImage = Image.asset('assets/kibla/compass_1.png', fit: BoxFit.fill,);
  Image _needleImage = Image.asset('assets/kibla/needle_1.png', fit: BoxFit.fill,);

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    /*
    EasyLoading.instance
      ..backgroundColor = Colors.white
      ..indicatorColor = Provider.of<ThemeProvider>(context, listen: false).appBarColor
      ..textColor = Provider.of<ThemeProvider>(context, listen: false).appBarColor
      ..dismissOnTap = true
      ..loadingStyle = EasyLoadingStyle.light;
    */

    int compassNumber = PreferenceUtils.getInt(Configuration.PRAYER_TIMES_COMPASS_NUMBER, 1);
    switch(compassNumber){
      case 1: compass_1_handler(); break;
      case 2: compass_2_handler(); break;
      case 3: compass_3_handler(); break;
    }
  }

  void locationHandler() async{
    setState(() {
      _qiblaErrorMessage = '';
    });
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
          _qiblaErrorMessage = translate('please_enable_GPS_location');
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
          _qiblaErrorMessage = translate('please_allow_the_app_to_get_your_location');
        });
        EasyLoading.dismiss(animation: true);
        return;
      }
    }

    _locationData = await location.getLocation().timeout(Duration(seconds: 10),onTimeout: (){
      setState(() {
        _qiblaErrorMessage = translate('try_moving_your_phone');
      });
      EasyLoading.dismiss(animation: true);
      return _locationData!;
    });

    if(_locationData == null){
      return;
    }else{
      Provider.of<SettingsProvider>(context, listen: false).longitude = _locationData.longitude.toString();
      Provider.of<SettingsProvider>(context, listen: false).latitude = _locationData.latitude.toString();

      //Provider.of<SettingsProvider>(context, listen: false).LocationLongLat.clear();
      //Provider.of<SettingsProvider>(context, listen: false).LocationLongLat = {'longitude': _locationData.longitude.toString(), 'latitude': _locationData.latitude.toString()};

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

      EasyLoading.dismiss(animation: true);
      setState(() {
        _qiblaErrorMessage = '';
        _qiblaDirection = QiblaDirectionCalculator.getQiblaDirectionFromNorth(_locationData!.longitude!, _locationData.latitude!);
        _qiblaInfoMessage = translate('Location')+' : ' + Provider.of<SettingsProvider>(context, listen: false).country +' / '+ Provider.of<SettingsProvider>(context, listen: false).city;
      });
    }
  }

  void compass_1_handler(){
    PreferenceUtils.setInt(Configuration.PRAYER_TIMES_COMPASS_NUMBER, 1);
    setState(() {
      _compassImage = Image.asset('assets/kibla/compass_1.png', fit: BoxFit.fill,);
      _needleImage = Image.asset('assets/kibla/needle_1.png', fit: BoxFit.fill,);
    });
  }

  void compass_2_handler(){
    PreferenceUtils.setInt(Configuration.PRAYER_TIMES_COMPASS_NUMBER, 2);
    setState(() {
      _compassImage = Image.asset('assets/kibla/compass_2.png', fit: BoxFit.fill,);
      _needleImage = Image.asset('assets/kibla/needle_2.png', fit: BoxFit.fill,);
    });
  }

  void compass_3_handler(){
    PreferenceUtils.setInt(Configuration.PRAYER_TIMES_COMPASS_NUMBER, 3);
    setState(() {
      _compassImage = Image.asset('assets/kibla/compass_3.png', fit: BoxFit.fill,);
      _needleImage = Image.asset('assets/kibla/needle_3.png', fit: BoxFit.fill,);
    });
  }


  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight,),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 0, right: 10, left: 10),
                      child: Text(_qiblaInfoMessage, style: TextStyle(fontSize: 14, color: Colors.green,),maxLines: 5,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(_qiblaErrorMessage, style: TextStyle(fontSize: 14, color: Colors.red,),maxLines: 5,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('Qibla_direction_from_North')+': '+_qiblaDirection.toInt().toString()+'°', style: TextStyle(fontSize: 14, color: Colors.blue,),maxLines: 5,),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: _buildCompass(),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 0, right: 10, left: 10),
                      child: Text(translate('qibla_warning'), style: TextStyle(fontSize: 14, color: Colors.red,),maxLines: 5,),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: compass_1_handler,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      backgroundImage: ExactAssetImage('assets/kibla/compass_1.png'),
                    ),
                  ),
                  InkWell(
                    onTap: compass_2_handler,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: ExactAssetImage('assets/kibla/compass_2.png'),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: compass_3_handler,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      backgroundImage: ExactAssetImage('assets/kibla/compass_3.png'),
                    ),
                  ),
                ],
              ),
            ),
            /*
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 0, right: 10, left: 10),
                      child: ElevatedButton.icon(
                        onPressed: locationHandler,
                        label: Text(
                          translate('Find_Qibla_Location'),
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            */
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _qiblaErrorMessage = translate('Error')+': ${snapshot.error}';
        }else{
          _qiblaErrorMessage ='';
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          _qiblaErrorMessage = translate('Please_wait');
        }else{
          _qiblaErrorMessage ='';
        }

        _qiblaDirection = QiblaDirectionCalculator.getQiblaDirectionFromNorth(double.parse(SettingsProvider().longitude), double.parse(SettingsProvider().latitude));
        _qiblaInfoMessage = translate('Location')+' : '+ SettingsProvider().country +' / '+ SettingsProvider().city;

        double? direction = 0;
        double finalQiblaDirection = 0;
        try{
          direction = snapshot.data!.heading;
          finalQiblaDirection = direction! + (360 - _qiblaDirection);
          _qiblaErrorMessage = '';
        }catch(e){
          _qiblaErrorMessage = translate('Error')+': '+e.toString();
        }

        if (direction == null){
          _qiblaErrorMessage = translate('Device_does_not_have_sensors');
        }else{
          _qiblaErrorMessage ='';
        }

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 250,
              height: 250,
              child: Transform.rotate(
                angle: (direction! * (math.pi / 180) * -1),
                child: _compassImage,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 230,
              height: 230,
              child: Transform.rotate(
                angle: (finalQiblaDirection * (math.pi / 180) * -1),
                child: _needleImage,
              ),
            ),
          ],
        );
      },
    );
  }


}