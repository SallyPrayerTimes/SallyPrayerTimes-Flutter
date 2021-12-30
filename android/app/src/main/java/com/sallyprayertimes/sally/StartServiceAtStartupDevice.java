package com.sallyprayertimes.sally;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.content.ContextCompat;

import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.Calendar;

public class StartServiceAtStartupDevice extends BroadcastReceiver{
    @Override
    public void onReceive(Context context, Intent intent) {

        if(intent.getAction().equalsIgnoreCase(Intent.ACTION_BOOT_COMPLETED))
        {
            AlarmManager am = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
            Intent AthanServiceBroasdcastReceiverIntent = new Intent(context, RefreshDayAndTimeServiceManager.class);
            PendingIntent pi = PendingIntent.getBroadcast(context, PreferenceHandler.NextDayIntentRequestCode, AthanServiceBroasdcastReceiverIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            am.cancel(pi);

            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.HOUR_OF_DAY, 00);
            calendar.set(Calendar.MINUTE, 01);
            calendar.set(Calendar.SECOND, 00);

            am.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, pi);

            PreferenceHandler.getSingleton().setContext(context);
            PrayersTimes.getSingleton().init(context);
            AthanServiceBroasdcastReceiver.startNextPrayer(context);

            if(SmallWidgetProvider.isEnabled){
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    ContextCompat.startForegroundService(context,new Intent(context, SmallWidgetProviderService.class));
                }
                else {
                    context.startService(new Intent(context, SmallWidgetProviderService.class));
                }
            }
        }
    }
}
