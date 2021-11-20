package com.sallyprayertimes.sally;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Toast;

public class PreferenceHandler {

    public static int AthanIntentRequestCode = 25;
    public static int NextDayIntentRequestCode = 55;
    public static int RefreshWidgetIntentRequestCode = 95;

    public static String PREFIX = "flutter.";
    public static String PRAYER_TIMES_LONGITUDE = "PRAYER_TIMES_LONGITUDE";
    public static String PRAYER_TIMES_LATITUDE = "PRAYER_TIMES_LATITUDE";
    public static String PRAYER_TIMES_TIMEZONE = "PRAYER_TIMES_TIMEZONE";
    public static String PRAYER_TIMES_HIJRI_ADJUSTMENT = "PRAYER_TIMES_HIJRI_ADJUSTMENT";
    public static String PRAYER_TIMES_TYPE_TIME = "PRAYER_TIMES_TYPE_TIME";
    public static String PRAYER_TIMES_MADHAB = "PRAYER_TIMES_MADHAB";
    public static String PRAYER_TIMES_CALCULATION_METHOD = "PRAYER_TIMES_CALCULATION_METHOD";
    public static String PRAYER_TIMES_FAJR_ATHAN_TYPE = "PRAYER_TIMES_FAJR_ATHAN_TYPE";
    public static String PRAYER_TIMES_SHOROUK_ATHAN_TYPE = "PRAYER_TIMES_SHOROUK_ATHAN_TYPE";
    public static String PRAYER_TIMES_DUHR_ATHAN_TYPE = "PRAYER_TIMES_DUHR_ATHAN_TYPE";
    public static String PRAYER_TIMES_ASR_ATHAN_TYPE = "PRAYER_TIMES_ASR_ATHAN_TYPE";
    public static String PRAYER_TIMES_MAGHRIB_ATHAN_TYPE = "PRAYER_TIMES_MAGHRIB_ATHAN_TYPE";
    public static String PRAYER_TIMES_ISHAA_ATHAN_TYPE = "PRAYER_TIMES_ISHAA_ATHAN_TYPE";
    public static String PRAYER_TIMES_FAJR_TIME_ADJUSTMENT = "PRAYER_TIMES_FAJR_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_SHOROUK_TIME_ADJUSTMENT = "PRAYER_TIMES_SHOROUK_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_DUHR_TIME_ADJUSTMENT = "PRAYER_TIMES_DUHR_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_ASR_TIME_ADJUSTMENT = "PRAYER_TIMES_ASR_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_MAGHRIB_TIME_ADJUSTMENT = "PRAYER_TIMES_MAGHRIB_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_ISHAA_TIME_ADJUSTMENT = "PRAYER_TIMES_ISHAA_TIME_ADJUSTMENT";
    public static String PRAYER_TIMES_ATHAN = "PRAYER_TIMES_ATHAN";
    public static String WIDGET_BACKGROUND_COLOR = "WIDGET_BACKGROUND_COLOR";
    public static String PRAYER_TIMES_LANGUAGE = "PRAYER_TIMES_LANGUAGE";

    public static String UmmAlQuraUniv =  "UmmAlQuraUniv";
    public static String EgytionGeneralAuthorityofSurvey = "EgytionGeneralAuthorityofSurvey";
    public static String UnivOfIslamicScincesKarachi =  "UnivOfIslamicScincesKarachi";
    public static String IslamicSocietyOfNorthAmerica = "IslamicSocietyOfNorthAmerica";
    public static String MuslimWorldLeague = "MuslimWorldLeague";
    public static String FederationofIslamicOrganizationsinFrance = "FederationofIslamicOrganizationsinFrance";
    public static String TheMinistryofAwqafandIslamicAffairsinKuwait = "TheMinistryofAwqafandIslamicAffairsinKuwait";
    public static String InstituteOfGeophysicsUniversityOfTehran = "InstituteOfGeophysicsUniversityOfTehran";
    public static String ShiaIthnaAshariLevaInstituteQum = "ShiaIthnaAshariLevaInstituteQum";
    public static String GulfRegion = "GulfRegion";
    public static String Qatar = "Qatar";
    public static String MajlisUgamaIslamSingapuraSingapore = "MajlisUgamaIslamSingapuraSingapore";
    public static String DirectorateOfReligiousAffairsTurkey = "DirectorateOfReligiousAffairsTurkey";
    public static String SpiritualAdministrationOfMuslimsOfRussia = "SpiritualAdministrationOfMuslimsOfRussia";
    public static String TheGrandeMosqueedeParis = "TheGrandeMosqueedeParis";
    public static String AlgerianMinisterofReligiousAffairsandWakfs = "AlgerianMinisterofReligiousAffairsandWakfs";
    public static String JabatanKemajuanIslamMalaysia = "JabatanKemajuanIslamMalaysia";
    public static String TunisianMinistryofReligiousAffairs = "TunisianMinistryofReligiousAffairs";
    public static String UAEGeneralAuthorityofIslamicAffairsAndEndowments = "UAEGeneralAuthorityofIslamicAffairsAndEndowments";

    public static String hanafi = "hanafi";
    public static String summery = "summery";

    public static String athan = "athan";
    public static String vibration = "vibration";
    public static String notification = "notification";

    public static String ali_ben_ahmed_mala = "ali_ben_ahmed_mala";
    public static String abd_el_basset_abd_essamad = "abd_el_basset_abd_essamad";
    public static String farou9_abd_errehmane_hadraoui = "farou9_abd_errehmane_hadraoui";
    public static String mohammad_ali_el_banna = "mohammad_ali_el_banna";
    public static String mohammad_khalil_raml = "mohammad_khalil_raml";

    private Context context;

    private static PreferenceHandler preferenceHandler;

    private String MY_PREFS_NAME = "FlutterSharedPreferences";

    public static PreferenceHandler getSingleton() {
        if (preferenceHandler == null) {
            preferenceHandler = new PreferenceHandler();
        }
        return preferenceHandler;
    }

    public void setContext(Context context){
        this.context = context;
    }

    public String getValue(String key, String defaultValue)
    {
        SharedPreferences prefs = context.getSharedPreferences(MY_PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(PREFIX + key, defaultValue);
    }

    public void setValue(String key, String value)
    {
        SharedPreferences.Editor editor = context.getSharedPreferences(MY_PREFS_NAME, Context.MODE_PRIVATE).edit();
        editor.putString(PREFIX + key, value);
        editor.commit();
    }
}
