package com.sallyprayertimes.sally;

import org.joda.time.Chronology;
import org.joda.time.LocalDate;
import org.joda.time.chrono.ISOChronology;
import org.joda.time.chrono.IslamicChronology;

import java.util.Calendar;

public class HijriTime {


    public static boolean isRamadan()
    {
        Calendar calendar = Calendar.getInstance();

        int hijriTimeAdjustment = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_HIJRI_ADJUSTMENT, "0"));

        calendar.add(Calendar.DAY_OF_MONTH, hijriTimeAdjustment);

        int day = calendar.get(Calendar.DAY_OF_MONTH);
        int month = calendar.get(Calendar.MONTH) + 1;
        int year = calendar.get(Calendar.YEAR);

        Chronology iSOChronology = ISOChronology.getInstanceUTC();
        Chronology islamicChronology = IslamicChronology.getInstanceUTC();

        LocalDate localDateISOChronology = new LocalDate(year, month, day, iSOChronology);
        LocalDate HijriDate = new LocalDate(localDateISOChronology.toDate(), islamicChronology);

        return HijriDate.getMonthOfYear() == 9;
    }

}
