/*
import 'dart:async';

import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/hwlocation.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_availability.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_result.dart';
import 'package:huawei_location/location/location_settings_request.dart';
import 'package:huawei_location/location/location_settings_states.dart';
import 'package:huawei_location/permission/permission_handler.dart';

class HuaweiLocationservice{

  late PermissionHandler permissionHandler;
  late FusedLocationProviderClient locationService;
  late List<LocationRequest> locationRequestList;
  late LocationSettingsRequest locationSettingsRequest;
  late LocationRequest locationRequest;
  late LocationCallback locationCallback;
  late Location myLocation;

  int callbackId = 0;
  int callbackId_2 = 0;

  HuaweiLocationservice(){
    locationService = FusedLocationProviderClient();
    permissionHandler = PermissionHandler();
    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY;
    locationRequestList = <LocationRequest>[locationRequest];
    locationSettingsRequest = LocationSettingsRequest(requests: locationRequestList, needBle: true, alwaysShow: true);
    locationCallback = LocationCallback(onLocationAvailability: _onLocationAvailability,onLocationResult: _onLocationResult);
  }

  void _onLocationResult(LocationResult res) {
    if(res.lastLocation != null){
      myLocation = res.lastLocation!;
    }
    print("_onLocationResult: "+res.toString());
  }

  void _onLocationAvailability(LocationAvailability availability) {
    print("_onLocationAvailability: "+availability.toString());
  }

  Future<int> requestLocationUpdatesMethod() async {
    if (callbackId == 0) {
      try {
        int _callbackId_2 = await locationService.requestLocationUpdatesCb(locationRequest, locationCallback);
        int? _callbackId = await locationService.requestLocationUpdates(locationRequest);
        callbackId_2 = _callbackId_2;
        callbackId = _callbackId!;
        return callbackId;
        print("Location updates requested successfully");
      } catch (e) {
        callbackId == 0;
        return 0;
        print("Error1: "+e.toString());
      }
    } else {
      return 0;
      print("Already requested location updates. Try removing location updates");
    }
  }

  Future<LocationSettingsStates> checkLocationSettings() async {
    try {
      LocationSettingsStates states = await locationService.checkLocationSettings(locationSettingsRequest);
      return states;
    } catch (e) {
      return LocationSettingsStates(
          bleUsable: false,
          gnssPresent: false,
          gpsPresent: false,
          hmsLocationPresent: false,
          locationPresent: false,
          networkLocationPresent: false,
          networkLocationUsable: false,
          locationUsable: false,
          gpsUsable: false,
          gnssUsable: false,
          blePresent: false,
          hmsLocationUsable: false
      );
    }
  }

  Future<bool> hasPermission() async {
    try {
      bool status = await permissionHandler.hasLocationPermission();
      return status;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      bool status = await permissionHandler.requestLocationPermission();
      return status;
      if(status == true){
        return true;
      }else{
        bool status2 = await permissionHandler.hasBackgroundLocationPermission();
        if(status2 == true){
          return true;
        }else{
          bool status3 = await permissionHandler.requestBackgroundLocationPermission();
          return status3;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<Location> getLastLocation() async {
    try {
      Location location = await locationService.getLastLocation();
      if(location != null && location.longitude != 0 && location.latitude != 0){
        locationService.removeLocationUpdates(callbackId);
        locationService.removeLocationUpdatesCb(callbackId_2);
        callbackId = 0;
        callbackId_2 = 0;
        return location;
      }
      else{
        if(myLocation != null && myLocation.longitude != 0 && myLocation.latitude != 0)
        {
          locationService.removeLocationUpdates(callbackId);
          locationService.removeLocationUpdatesCb(callbackId_2);
          callbackId = 0;
          callbackId_2 = 0;
          return myLocation;
        }else{
          callbackId = 0;
          int? callBackId = await requestLocationUpdatesMethod();
          Location location = await locationService.getLastLocation();
          callbackId = 0;
          return location;
        }
      }
    } catch (e) {
      return new Location();
    }
  }

}
*/