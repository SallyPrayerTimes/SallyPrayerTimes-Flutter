

import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';

class HuaweiHelper {

  static Future<HuaweiHelper> get _instance async => _huaweiHelper ??= await HuaweiHelper.getInstance();
  static HuaweiHelper? _huaweiHelper;

  // call this method from iniState() function of mainApp().
  static Future<HuaweiHelper?> init() async {
    isHms = await HmsApiAvailability().isHMSAvailable();
    _huaweiHelper = await _instance;
    return _huaweiHelper;
  }

  static HuaweiHelper getInstance(){
    return new HuaweiHelper();
  }

  static int isHms = 645423;

  static bool get isHmsAviable{
    // 0: HMS Core (APK) is available.
    // 1: No HMS Core (APK) is found on device.
    // 2: HMS Core (APK) installed is out of date.
    // 3: HMS Core (APK) installed on the device is unavailable.
    // 9: HMS Core (APK) installed on the device is not the official version.
    // 21: The device is too old to support HMS Core (APK).
    if(isHms == 0 || isHms == 2 || isHms == 3 || isHms == 9){
      return true;
    }else{
      return false;
    }
  }
}
