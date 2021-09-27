
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class QiblaDirectionCalculator {
  static final double QIBLA_LATITUDE = radians(21.422487);
  static final double QIBLA_LONGITUDE = radians(39.826206);

  static double getQiblaDirectionFromNorth(double degLongitude,double degLatitude) {
    double latitude = radians(degLatitude);
    double longitude = radians(degLongitude);

    double soorat = sin(QIBLA_LONGITUDE - longitude);
    double makhraj = cos(latitude) * tan(QIBLA_LATITUDE)- sin(latitude) * cos(QIBLA_LONGITUDE - longitude);
    double returnValue = degrees(atan(soorat / makhraj));

    if (latitude > QIBLA_LATITUDE) {
      if ((longitude > QIBLA_LONGITUDE || longitude < (
          radians(-180) + QIBLA_LONGITUDE))
          && (returnValue > 0 && returnValue <= 90)) {

        returnValue += 180;

      } else if (!(longitude > QIBLA_LONGITUDE || longitude < (
          radians(-180) + QIBLA_LONGITUDE))
          && (returnValue > -90 && returnValue < 0)) {

        returnValue += 180;

      }

    }
    if (latitude < QIBLA_LATITUDE) {

      if ((longitude > QIBLA_LONGITUDE || longitude < (
          radians(-180) + QIBLA_LONGITUDE))
          && (returnValue > 0 && returnValue < 90)) {

        returnValue += 180;

      }
      if (!(longitude > QIBLA_LONGITUDE || longitude < (
          radians(-180) + QIBLA_LONGITUDE))
          && (returnValue > -90 && returnValue <= 0)) {
        returnValue += 180;
      }

    }
    return returnValue;
  }

}
