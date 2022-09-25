import 'dart:core';
import 'dart:math' as Math;
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Providers/PrayersProvider.dart';
import 'package:sally_prayer_times/Providers/SettingsProvider.dart';
import 'package:sally_prayer_times/Prayer/HijriMiladiTimes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Providers/SettingsProvider.dart';

class PrayerTimes{
  final double DegToRad = 0.017453292;
  final double RadToDeg = 57.29577951;
  double dec = 0;
  double fajrAlt = 0;
  double ishaAlt = 0;
  late List allPrayrTimesInMinutes;

  late String fajrTime;
  late String shoroukTime;
  late String duhrime;
  late String asrTime;
  late String maghribTime;
  late String ishaaTime;

  PrayerTimes(int day, int month, int year){

    month-=1;//java start months numbers from 0 to 11 , dart start from 1 to 12

    double longitude = double.parse(SettingsProvider().longitude);
    double latitude = double.parse(SettingsProvider().latitude);
    double timezone = double.parse(SettingsProvider().timezone);

    String calculationMethod = SettingsProvider().calculationMethod;
    String madhab = SettingsProvider().madhab;
    String typeTime = SettingsProvider().typeTime;

    int fajrTimeAdjustment = int.parse(SettingsProvider().fajrTimeAdjustment);
    int shoroukTimeAdjustment = int.parse(SettingsProvider().shoroukTimeAdjustment);
    int duhrTimeAdjustment = int.parse(SettingsProvider().duhrTimeAdjustment);
    int asrTimeAdjustment = int.parse(SettingsProvider().asrTimeAdjustment);
    int maghribTimeAdjustment = int.parse(SettingsProvider().maghribTimeAdjustment);
    int ishaaTimeAdjustment = int.parse(SettingsProvider().ishaaTimeAdjustment);

    // ---------------------- Calculation Functions -----------------------
    // References:
    // http://www.icoproject.org/
    // http://qasweb.org/

    double julianDay = (((((367 * year) - (((year + (((month + 1) + 9) / 12)) * 7) / 4)) + ((275 * (month + 1)) / 9)) + day) - 730531.5);
    double sunLength = removeDublication(280.461 + (0.9856474 * julianDay));
    double middleSun = removeDublication(357.528 + (0.9856003 * julianDay));
    double lambda = removeDublication((sunLength + (1.915 * Math.sin(middleSun * DegToRad))) + (0.02 * Math.sin((2 * middleSun) * DegToRad)));
    double obliquity = (23.439 - (4e-7 * julianDay));
    double alpha = (RadToDeg * Math.atan(Math.cos(obliquity * DegToRad) * Math.tan(lambda * DegToRad)));

    if ((lambda > 90) && (lambda < 180)) {
      alpha += 180;
    } else {
      if ((lambda > 180) && (lambda < 360)) {
        alpha += 360;
      }
    }

    double st = removeDublication(100.46 + (0.985647352 * julianDay));

    this.dec = (RadToDeg * Math.asin(Math.sin(obliquity * DegToRad) * Math.sin(lambda * DegToRad)));
    double noon = (alpha - st);
    if (noon < 0) {
      noon += 360;
    }

    double UTNoon = (noon - longitude);
    double localNoon = ((UTNoon / 15) + timezone);

    double duhr = localNoon;
    double maghrib = (localNoon + (equation(-0.8333, latitude) / 15));
    double shorou9 = (localNoon - (equation(-0.8333, latitude) / 15));

    if(calculationMethod == Configuration.MuslimWorldLeagueKey){
      this.fajrAlt = -18;
      this.ishaAlt = -17;
    } else if (calculationMethod == Configuration.IslamicSocietyOfNorthAmericaKey){
      this.fajrAlt = -15;
      this.ishaAlt = -15;
    } else if (calculationMethod == Configuration.EgytionGeneralAuthorityofSurveyKey){
      this.fajrAlt = -19.5;
      this.ishaAlt = -17.5;
    } else if (calculationMethod == Configuration.UmmAlQuraUnivKey){
      this.fajrAlt = -18.5;// fajr was 19 degrees before 1430 hijri
    } else if (calculationMethod == Configuration.UnivOfIslamicScincesKarachiKey) {
      this.fajrAlt = -18;
      this.ishaAlt = -18;
    } else if (calculationMethod == Configuration.InstituteOfGeophysicsUniversityOfTehranKey) {
      this.fajrAlt = -17.7;
      this.ishaAlt = -14;
    } else if (calculationMethod == Configuration.ShiaIthnaAshariLevaInstituteQumKey) {
      this.fajrAlt = -16;
      this.ishaAlt = -14;
    } else if (calculationMethod == Configuration.GulfRegionKey) {
      this.fajrAlt = -19.5;
    } else if (calculationMethod == Configuration.TheMinistryofAwqafandIslamicAffairsinKuwaitKey) {
      this.fajrAlt = -18;
      this.ishaAlt = -17.5;
    } else if (calculationMethod == Configuration.QatarKey) {
      this.fajrAlt = -18;
    } else if (calculationMethod == Configuration.MajlisUgamaIslamSingapuraSingaporeKey) {
      this.fajrAlt = -20;
      this.ishaAlt = -18;
    } else if (calculationMethod == Configuration.FederationofIslamicOrganizationsinFranceKey) {
      this.fajrAlt = -12;
      this.ishaAlt = -12;
    } else if (calculationMethod == Configuration.DirectorateOfReligiousAffairsTurkeyKey) {
      this.fajrAlt = -18;
      this.ishaAlt = -17;
    } else if (calculationMethod == Configuration.SpiritualAdministrationOfMuslimsOfRussiaKey) {
      this.fajrAlt = -16;
      this.ishaAlt = -15;
    } else if (calculationMethod == Configuration.TheGrandeMosqueedeParis) {
      this.fajrAlt = -18;
      this.ishaAlt = -18;
    } else if (calculationMethod == Configuration.AlgerianMinisterofReligiousAffairsandWakfs) {
      this.fajrAlt = -18;
      this.ishaAlt = -17;
    } else if (calculationMethod == Configuration.JabatanKemajuanIslamMalaysia) {
      this.fajrAlt = -20;
      this.ishaAlt = -18;
    } else if (calculationMethod == Configuration.TunisianMinistryofReligiousAffairs) {
      this.fajrAlt = -18;
      this.ishaAlt = -18;
    } else if (calculationMethod == Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments) {
      this.fajrAlt = -19.5;
    }

    double fajr = (localNoon - (equation(fajrAlt, latitude) / 15));
    double ishaa = (localNoon + (equation(ishaAlt, latitude) / 15));
    if (calculationMethod == Configuration.UmmAlQuraUnivKey || calculationMethod == Configuration.GulfRegionKey || calculationMethod == Configuration.QatarKey || calculationMethod == Configuration.UAEGeneralAuthorityofIslamicAffairsAndEndowments) {
      try {
        if(HijriTime().isRamadan)
        {
          ishaa = maghrib + 2;
        } else {
          ishaa = maghrib + 1.5;
        }
      } catch(ex){
        ishaa = maghrib + 1.5;
      }
    }
    double asrAlt;

    if (madhab == Configuration.hanafiKey) {
      asrAlt = (90 - (RadToDeg * Math.atan(2 + Math.tan(abs(latitude - dec) * DegToRad))));
    } else {
      asrAlt = (90 - (RadToDeg * Math.atan(1 + Math.tan(abs(latitude - dec) * DegToRad))));
    }

    double asr = (localNoon + (equation(asrAlt, latitude) / 15));

    if (typeTime == Configuration.summeryKey) {
      fajr += 1;
      shorou9 += 1;
      duhr += 1;
      asr += 1;
      maghrib += 1;
      ishaa += 1;
    }

    this.allPrayrTimesInMinutes = new List.filled(6, null, growable: false);

    this.allPrayrTimesInMinutes[0] = (getMinutes(fajr) + fajrTimeAdjustment).toInt();
    this.allPrayrTimesInMinutes[1] = (getMinutes(shorou9) + shoroukTimeAdjustment).toInt();
    this.allPrayrTimesInMinutes[2] = (getMinutes(duhr) + duhrTimeAdjustment).toInt();
    this.allPrayrTimesInMinutes[3] = (getMinutes(asr) + asrTimeAdjustment).toInt();
    this.allPrayrTimesInMinutes[4] = (getMinutes(maghrib) + maghribTimeAdjustment).toInt();
    this.allPrayrTimesInMinutes[5] = (getMinutes(ishaa) + ishaaTimeAdjustment).toInt();

    for (int i = 0; i < allPrayrTimesInMinutes.length; i++) {
      if(i == 0 || i == 1){
        while(allPrayrTimesInMinutes[i] > 720){
          allPrayrTimesInMinutes[i] -= 720;
        }
      }else{
        while(allPrayrTimesInMinutes[i] > 1440){
          allPrayrTimesInMinutes[i] -= 720;
        }
      }
    }

    fajrTime = getFinaleSalatTime(allPrayrTimesInMinutes[0]);
    shoroukTime = getFinaleSalatTime(allPrayrTimesInMinutes[1]);
    duhrime = getFinaleSalatTime(allPrayrTimesInMinutes[2]);
    asrTime = getFinaleSalatTime(allPrayrTimesInMinutes[3]);
    maghribTime = getFinaleSalatTime(allPrayrTimesInMinutes[4]);
    ishaaTime = getFinaleSalatTime(allPrayrTimesInMinutes[5]);

  }

  static String getFinaleSalatTime(int salatTime)
  {
    int salatHour = (salatTime / 60).toInt();
    int salatMinutes = salatTime % 60;

    if ((SettingsProvider().time12_24 == Configuration.time12or24_12) && (salatHour > 12)) {
      salatHour -= 12;
    }
    return (salatHour.toString().padLeft(2, '0') + ":" + salatMinutes.toString().padLeft(2, '0'));
  }

  double removeDublication(double d) {
    if (d > 360) {
      d /= 360;
      d -= d.toInt();
      d *= 360;
    }
    return d;
  }

  double equation(double d, double latitude)
  {
    return RadToDeg * Math.acos((Math.sin(d * DegToRad) - (Math.sin(dec * DegToRad) * Math.sin(latitude * DegToRad))) / (Math.cos(dec * DegToRad) * Math.cos(latitude * DegToRad)));
  }

  double abs(double d) {
    if (d < 0) {
      return -d;
    } else {
      return d;
    }
  }

  static int getMinutes(double d) {//get minutes from calculated prayer time
    int h = d.toInt();
    int m = (((d - h) * 60).ceil()).toInt();
    return (h * 60) + m;
  }

}

