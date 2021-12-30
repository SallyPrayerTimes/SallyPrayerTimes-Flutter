package com.sallyprayertimes.sally;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.Calendar;
import java.util.TimeZone;

public class RefreshDayAndTimeServiceManager extends BroadcastReceiver{
    @Override
    public void onReceive(Context context, Intent intent) {

        try{
            TimeZone timezone = TimeZone.getDefault();
            int offsetInMillis = timezone.getOffset(System.currentTimeMillis());
            String offset = String.format("%02d.%02d", Math.abs(offsetInMillis / 3600000), Math.abs((offsetInMillis / 60000) % 60));
            String timeZoneOffset = (offsetInMillis >= 0 ? "" : "-") + offset;

            PreferenceHandler.getSingleton().setValue(PreferenceHandler.PRAYER_TIMES_TIMEZONE, timeZoneOffset);
        }catch(Exception ex){}

        PreferenceHandler.getSingleton().setContext(context);
        PrayersTimes.getSingleton().init(context);
        AthanServiceBroasdcastReceiver.startNextPrayer(context);

        if(SmallWidgetProvider.isEnabled){
            context.startService(new Intent(context, SmallWidgetProviderService.class));
        }
    }
}
