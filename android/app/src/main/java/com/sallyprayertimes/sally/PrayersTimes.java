package com.sallyprayertimes.sally;

import android.content.Context;
import android.widget.Toast;

import java.util.Calendar;

public class PrayersTimes {

    public static int nextPrayerTimeCode;

    private static PrayersTimes prayersTimes;

    public static PrayersTimes getSingleton() {
        if (prayersTimes == null) {
            prayersTimes = new PrayersTimes();
        }
        return prayersTimes;
    }

    static public int[] allPrayrTimesInMinutes;

    private final double DegToRad = 0.017453292;
    private final double RadToDeg = 57.29577951;
    private double dec;
    private double fajrAlt;
    private double ishaAlt;

    public void init(Context context) {

        double longitude = Double.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_LONGITUDE, "39.8409"));
        double latitude = Double.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_LATITUDE, "21.4309"));
        double timezone = Double.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_TIMEZONE, "3.0"));

        String calculationMethod = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_CALCULATION_METHOD, PreferenceHandler.MuslimWorldLeague);
        String madhab = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_MADHAB, "shafi3i");
        String typeTime = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_TYPE_TIME, "standard");

        int fajrTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_FAJR_TIME_ADJUSTMENT, "0"));
        int shoroukTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_SHOROUK_TIME_ADJUSTMENT, "0"));
        int duhrTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_DUHR_TIME_ADJUSTMENT, "0"));
        int asrTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_ASR_TIME_ADJUSTMENT, "0"));
        int maghribTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_MAGHRIB_TIME_ADJUSTMENT, "0"));
        int ishaaTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_ISHAA_TIME_ADJUSTMENT, "0"));

        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH);
        int day = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);

        // ---------------------- Calculation Functions -----------------------
        // References:
        // http://www.icoproject.org/
        // http://qasweb.org/
        double julianDay = (367 * year) - (int) (((year + (int) (((month + 1) + 9) / 12)) * 7) / 4) + (int) (275 * (month + 1) / 9) + day - 730531.5;
        double sunLength = removeDublication(280.461 + 0.9856474 * julianDay);
        double middleSun = removeDublication(357.528 + 0.9856003 * julianDay);
        double lambda = removeDublication(sunLength + 1.915 * Math.sin(middleSun * DegToRad) + 0.02 * Math.sin(2 * middleSun * DegToRad));
        double obliquity = 23.439 - (0.0000004 * julianDay);
        double alpha = RadToDeg * Math.atan(Math.cos(obliquity * DegToRad) * Math.tan(lambda * DegToRad));

        if (lambda > 90 && lambda < 180) {
            alpha += 180;
        } else if (lambda > 180 && lambda < 360) {
            alpha += 360;
        }

        double st = removeDublication(100.46 + 0.985647352 * julianDay);

        this.dec = RadToDeg * Math.asin(Math.sin(obliquity * DegToRad) * Math.sin(lambda * DegToRad));

        double noon = alpha - st;
        if (noon < 0) {
            noon += 360;
        }
        double UTNoon = noon - longitude;

        double localNoon = (UTNoon / 15) + timezone;

        double duhr = localNoon;
        double maghrib = localNoon + equation(-0.8333, latitude) / 15;
        double shorou9 = localNoon - equation(-0.8333, latitude) / 15;

        if(calculationMethod.equalsIgnoreCase(PreferenceHandler.MuslimWorldLeague))
        {
            this.fajrAlt = -18;
            this.ishaAlt = -17;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.IslamicSocietyOfNorthAmerica)) {
            this.fajrAlt = -15;
            this.ishaAlt = -15;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.EgytionGeneralAuthorityofSurvey)) {
            this.fajrAlt = -19.5;
            this.ishaAlt = -17.5;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.UmmAlQuraUniv)) {
            this.fajrAlt = -18.5;// fajr was 19 degrees before 1430 hijri
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.UnivOfIslamicScincesKarachi)) {
            this.fajrAlt = -18;
            this.ishaAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.InstituteOfGeophysicsUniversityOfTehran)) {
            this.fajrAlt = -17.7;
            this.ishaAlt = -14;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.ShiaIthnaAshariLevaInstituteQum)) {
            this.fajrAlt = -16;
            this.ishaAlt = -14;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.GulfRegion)) {
            this.fajrAlt = -19.5;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.TheMinistryofAwqafandIslamicAffairsinKuwait)) {
            this.fajrAlt = -18;
            this.ishaAlt = -17.5;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.Qatar)) {
            this.fajrAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.MajlisUgamaIslamSingapuraSingapore)) {
            this.fajrAlt = -20;
            this.ishaAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.FederationofIslamicOrganizationsinFrance)) {
            this.fajrAlt = -12;
            this.ishaAlt = -12;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.DirectorateOfReligiousAffairsTurkey)) {
            this.fajrAlt = -18;
            this.ishaAlt = -17;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.SpiritualAdministrationOfMuslimsOfRussia)) {
            this.fajrAlt = -16;
            this.ishaAlt = -15;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.TheGrandeMosqueedeParis )) {
            this.fajrAlt = -18;
            this.ishaAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.AlgerianMinisterofReligiousAffairsandWakfs )) {
            this.fajrAlt = -18;
            this.ishaAlt = -17;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.JabatanKemajuanIslamMalaysia )) {
            this.fajrAlt = -20;
            this.ishaAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.TunisianMinistryofReligiousAffairs )) {
            this.fajrAlt = -18;
            this.ishaAlt = -18;
        }
        else if (calculationMethod.equalsIgnoreCase(PreferenceHandler.UAEGeneralAuthorityofIslamicAffairsAndEndowments )) {
            this.fajrAlt = -19.5;
        }

        double fajr = localNoon - equation(fajrAlt, latitude) / 15;

        double ishaa = localNoon + equation(ishaAlt, latitude) / 15;

        if (calculationMethod.equalsIgnoreCase(PreferenceHandler.UmmAlQuraUniv) || calculationMethod.equalsIgnoreCase(PreferenceHandler.GulfRegion) || calculationMethod.equalsIgnoreCase(PreferenceHandler.Qatar) || calculationMethod.equalsIgnoreCase(PreferenceHandler.UAEGeneralAuthorityofIslamicAffairsAndEndowments)) {
            try {
                if(HijriTime.isRamadan())
                {
                    ishaa = maghrib + 2;
                }
                else
                {
                    ishaa = maghrib + 1.5;
                }
            } catch(Exception ex){
                ishaa = maghrib + 1.5;
            }
        }
        double asrAlt;

        if (madhab.equalsIgnoreCase(PreferenceHandler.hanafi)) {
            asrAlt = 90 - RadToDeg * Math.atan(2 + Math.tan(abs(latitude - dec) * DegToRad));
        } else {
            asrAlt = 90 - RadToDeg * Math.atan(1 + Math.tan(abs(latitude - dec) * DegToRad));
        }

        double asr = localNoon + equation(asrAlt, latitude) / 15;

        if (typeTime.equalsIgnoreCase(PreferenceHandler.summery)) {
            fajr += 1;
            shorou9 += 1;
            duhr += 1;
            asr += 1;
            maghrib += 1;
            ishaa += 1;
        }

        this.allPrayrTimesInMinutes = new int[6];

        this.allPrayrTimesInMinutes[0] = (int) (getMinutes(fajr) + fajrTimeAdjustment);
        this.allPrayrTimesInMinutes[1] = (int) (getMinutes(shorou9) + shoroukTimeAdjustment);
        this.allPrayrTimesInMinutes[2] = (int) (getMinutes(duhr) + duhrTimeAdjustment);
        this.allPrayrTimesInMinutes[3] = (int) (getMinutes(asr) + asrTimeAdjustment);
        this.allPrayrTimesInMinutes[4] = (int) (getMinutes(maghrib) + maghribTimeAdjustment);
        this.allPrayrTimesInMinutes[5] = (int) (getMinutes(ishaa) + ishaaTimeAdjustment);

        boolean b = true;

        while (b) {//adjust prayer times
            for (int i = 0; i < allPrayrTimesInMinutes.length; i++) {
                if (allPrayrTimesInMinutes[i] > 1440) {
                    for (int j = 0; j < allPrayrTimesInMinutes.length; j++) {
                        allPrayrTimesInMinutes[j] -= 720;
                    }
                    break;
                }
            }

            b = false;
        }

        this.nextPrayerTimeCode = getNextPrayer();
    }

    public double removeDublication(double d) {
        if (d > 360) {
            d /= 360;
            d -= (int) (d);
            d *= 360;
        }
        return d;
    }

    public double equation(double d, double latitude) {
        return RadToDeg
                * Math.acos((Math.sin(d * DegToRad) - Math
                .sin(dec * DegToRad) * Math.sin(latitude * DegToRad))
                / (Math.cos(dec * DegToRad) * Math.cos(latitude
                * DegToRad)));
    }

    public double abs(double d) {
        if (d < 0) {
            return -d;
        } else {
            return d;
        }
    }

    public static int getMinutes(double d) {//get minutes from calculated prayer time
        int h = (int) d;
        int m = (int) (Math.ceil((d - h) * 60));

        return (h * 60) + m;
    }

    public static int  getNextPrayer() {
        int i = 6;
        Calendar calendar = Calendar.getInstance();
        int totalMinutes = (calendar.get(Calendar.HOUR_OF_DAY) * 60) + (calendar.get(Calendar.MINUTE));
        if (totalMinutes == 0 || totalMinutes == 1440 || (totalMinutes >= 0 && totalMinutes <= allPrayrTimesInMinutes[0])) {
            i =  0;
        } else {
            if (totalMinutes > allPrayrTimesInMinutes[0] && totalMinutes <= allPrayrTimesInMinutes[1]) {
                i =  1;
            } else {
                if (totalMinutes > allPrayrTimesInMinutes[1] && totalMinutes <= allPrayrTimesInMinutes[2]) {
                    i =  2;
                } else {
                    if (totalMinutes > allPrayrTimesInMinutes[2] && totalMinutes <= allPrayrTimesInMinutes[3]) {
                        i =  3;
                    } else {
                        if (totalMinutes > allPrayrTimesInMinutes[3] && totalMinutes <= allPrayrTimesInMinutes[4]) {
                            i =  4;
                        } else {
                            if (totalMinutes > allPrayrTimesInMinutes[4] && totalMinutes <= allPrayrTimesInMinutes[5]) {
                                i =  5;
                            } else {
                                if (totalMinutes > allPrayrTimesInMinutes[5] && totalMinutes < 1440) {
                                    i =  6;
                                }
                            }
                        }
                    }
                }
            }
        }
        return  i;
    }

}
