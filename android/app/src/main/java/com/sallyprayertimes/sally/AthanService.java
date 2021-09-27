package com.sallyprayertimes.sally;

import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.IBinder;
import android.util.DisplayMetrics;

import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.Calendar;
import java.util.Locale;

public class AthanService extends Service{

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);

        AlarmManager am = (AlarmManager)this.getSystemService(Context.ALARM_SERVICE);
        Intent AthanServiceBroasdcastReceiverIntent = new Intent(getApplicationContext(), RefreshDayAndTimeServiceManager.class);
        PendingIntent pi = PendingIntent.getBroadcast(getApplicationContext(), PreferenceHandler.NextDayIntentRequestCode, AthanServiceBroasdcastReceiverIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        am.cancel(pi);

        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 00);
        calendar.set(Calendar.MINUTE, 01);
        calendar.set(Calendar.SECOND, 00);

        am.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, pi);

        PreferenceHandler.getSingleton().setContext(getApplicationContext());
        PrayersTimes.getSingleton().init(getApplicationContext());
        AthanServiceBroasdcastReceiver.startNextPrayer(getApplicationContext());

        if(SmallWidgetProvider.isEnabled){
            try{
                setAppLocale(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_LANGUAGE, "en"));
            }catch (Exception ex){}

            this.startService(new Intent(getApplicationContext(), SmallWidgetProviderService.class));
        }

        return Service.START_STICKY;
    }

    private void setAppLocale(String localeCode){
        String languageToLoad = localeCode;
        Locale locale = new Locale(languageToLoad);
        Locale.setDefault(locale);
        Configuration config = new Configuration();
        config.locale = locale;
        getBaseContext().getResources().updateConfiguration(config,getBaseContext().getResources().getDisplayMetrics());
    }

}

