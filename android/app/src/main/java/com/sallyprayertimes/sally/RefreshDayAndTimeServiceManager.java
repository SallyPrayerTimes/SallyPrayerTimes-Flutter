package com.sallyprayertimes.sally;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.Calendar;

public class RefreshDayAndTimeServiceManager extends BroadcastReceiver{
    @Override
    public void onReceive(Context context, Intent intent) {

        PreferenceHandler.getSingleton().setContext(context);
        PrayersTimes.getSingleton().init(context);
        AthanServiceBroasdcastReceiver.startNextPrayer(context);

        if(SmallWidgetProvider.isEnabled){
            context.startService(new Intent(context, SmallWidgetProviderService.class));
        }
    }
}
