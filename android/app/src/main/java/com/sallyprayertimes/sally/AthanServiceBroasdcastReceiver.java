package com.sallyprayertimes.sally;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioAttributes;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;

import com.sallyprayertimes.MainActivity;
import com.sallyprayertimes.R;
import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.Calendar;
import java.util.Locale;

public class AthanServiceBroasdcastReceiver extends BroadcastReceiver{

    @Override
    public void onReceive(Context context, Intent intent) {
        startAthan(context);
    }

    public static  void startAthan(Context context){
        startAthanNotification(context);

        if(SmallWidgetProvider.isEnabled){
            AlarmManager amRefreshWidget = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
            Intent intentRefreshWidget = new Intent(context, RefreshWidgetAfter15Minutes.class);
            PendingIntent piRefreshWidget = PendingIntent.getBroadcast(context, PreferenceHandler.RefreshWidgetIntentRequestCode , intentRefreshWidget, PendingIntent.FLAG_UPDATE_CURRENT);

            amRefreshWidget.cancel(piRefreshWidget);

            Calendar calendarRefreshWidget = Calendar.getInstance();
            calendarRefreshWidget.add(Calendar.MINUTE , 15);// update widget after 15 minutes from actual salat time

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                amRefreshWidget.setExactAndAllowWhileIdle(AlarmManager.RTC, calendarRefreshWidget.getTimeInMillis()  , piRefreshWidget);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                amRefreshWidget.setExact(AlarmManager.RTC, calendarRefreshWidget.getTimeInMillis()  , piRefreshWidget);
            } else {
                amRefreshWidget.set(AlarmManager.RTC, calendarRefreshWidget.getTimeInMillis()  , piRefreshWidget);
            }
        }

        PrayersTimes.nextPrayerTimeCode++;

        if(PrayersTimes.nextPrayerTimeCode < 6){
            startAlarmManager(context);
        }
    }
    public static void startNextPrayer(Context context)
    {
        if(PrayersTimes.nextPrayerTimeCode < 6)
        {
            startAlarmManager(context);
        }
    }

    private static void startAlarmManager(Context context)
    {
        Calendar calendar = Calendar.getInstance();

        AlarmManager am = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        Intent AthanServiceBroasdcastReceiverIntent = new Intent(context, AthanServiceBroasdcastReceiver.class);
        PendingIntent pi = PendingIntent.getBroadcast(context, PreferenceHandler.AthanIntentRequestCode, AthanServiceBroasdcastReceiverIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        am.cancel(pi);

        int nextPrayerMinutes = getNextPrayerTimeMinutes();
        int salatHour = nextPrayerMinutes / 60;
        int salatMinutes = nextPrayerMinutes % 60;

        calendar.set(Calendar.HOUR_OF_DAY , salatHour);
        calendar.set(Calendar.MINUTE , salatMinutes);
        calendar.set(Calendar.SECOND , 0);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC, calendar.getTimeInMillis()  , pi);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            am.setExact(AlarmManager.RTC, calendar.getTimeInMillis()  , pi);
        } else {
            am.set(AlarmManager.RTC, calendar.getTimeInMillis()  , pi);
        }
    }

    private static int getNextPrayerTimeMinutes()
    {
        int nextPrayerTimeMinutes = 0;
        switch (PrayersTimes.nextPrayerTimeCode)
        {
            case 0: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[0]; break;
            case 1: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[1]; break;
            case 2: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[2]; break;
            case 3: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[3]; break;
            case 4: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[4]; break;
            case 5: nextPrayerTimeMinutes = PrayersTimes.allPrayrTimesInMinutes[5]; break;
        }
        return nextPrayerTimeMinutes;
    }

    public static String getAthanAlertType(){
        String athanType = PreferenceHandler.athan;
        switch (PrayersTimes.nextPrayerTimeCode) {
            case 0:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_FAJR_ATHAN_TYPE, PreferenceHandler.athan);break;
            case 1:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_SHOROUK_ATHAN_TYPE, PreferenceHandler.athan);break;
            case 2:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_DUHR_ATHAN_TYPE, PreferenceHandler.athan);break;
            case 3:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_ASR_ATHAN_TYPE, PreferenceHandler.athan);break;
            case 4:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_MAGHRIB_ATHAN_TYPE, PreferenceHandler.athan);break;
            case 5:athanType = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_ISHAA_ATHAN_TYPE, PreferenceHandler.athan);break;
            default:break;
        }
        return athanType;
    }

    public static void startAthanNotification(Context context){
        try{
            String athanType = getAthanAlertType();
            if(athanType.equalsIgnoreCase(PreferenceHandler.athan) || athanType.equalsIgnoreCase(PreferenceHandler.vibration) || athanType.equalsIgnoreCase(PreferenceHandler.notification)){

                PowerManager powerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                PowerManager.WakeLock wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::MyWakelockTag");
                wakeLock.acquire(10000);

                String notification_channel_id = "sally_channel_id";
                String channelName = "Sally Prayer Times";

                NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);

                Bitmap largeIcon = BitmapFactory.decodeResource(context.getResources(), R.drawable.launcher_icon);

                Notification.Builder builder = null;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                        builder = (
                                new Notification.Builder(context)
                                .setDefaults(Notification.DEFAULT_ALL)
                                .setPriority(Notification.PRIORITY_HIGH)
                                .setSmallIcon(R.drawable.launcher_icon)
                                .setLargeIcon(largeIcon)
                                .setOngoing(false));
                    }
                }
                else{
                    return;
                }

                String actualAthanTime ="";
                switch (PrayersTimes.nextPrayerTimeCode){
                    case 0:actualAthanTime = context.getResources().getString(R.string.fajr);break;
                    case 1:actualAthanTime = context.getResources().getString(R.string.shorouk);break;
                    case 2:
                        if(Calendar.getInstance().get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY){
                            actualAthanTime = context.getResources().getString(R.string.jumuah);break;
                        }else{
                            actualAthanTime = context.getResources().getString(R.string.duhr);break;
                        }
                    case 3:actualAthanTime = context.getResources().getString(R.string.asr);break;
                    case 4:actualAthanTime = context.getResources().getString(R.string.maghrib);break;
                    case 5:actualAthanTime = context.getResources().getString(R.string.ishaa);break;
                    default:break;
                }

                if(!actualAthanTime.equals(""))
                {
                    channelName = actualAthanTime;
                }

                builder.setContentTitle(context.getResources().getString(R.string.notificationTitle)+" "+actualAthanTime);
                builder.setContentText(context.getResources().getString(R.string.notificationMessage)+" "+actualAthanTime);


                if(athanType.equalsIgnoreCase(PreferenceHandler.notification))
                {
                    builder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION));
                    notification_channel_id = "sally_channel_id_notification";
                }

                if(athanType.equalsIgnoreCase(PreferenceHandler.vibration))
                {
                    builder.setVibrate(new long[] {1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000});
                    notification_channel_id = "sally_channel_id_vibration";
                }

                Uri alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.ali_ben_ahmed_mala);
                if(athanType.equalsIgnoreCase(PreferenceHandler.athan))
                {
                    String athanName = PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_ATHAN, PreferenceHandler.ali_ben_ahmed_mala);
                    if(athanName.equalsIgnoreCase(PreferenceHandler.ali_ben_ahmed_mala)){
                        alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.ali_ben_ahmed_mala);
                        notification_channel_id = "sally_channel_id_athan_ali_ben_ahmed_mala";
                    }else{
                        if(athanName.equalsIgnoreCase(PreferenceHandler.abd_el_basset_abd_essamad)){
                            alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.abd_el_basset_abd_essamad);
                            notification_channel_id = "sally_channel_id_athan_abd_el_basset_abd_essamad";
                        }else{
                            if(athanName.equalsIgnoreCase(PreferenceHandler.farou9_abd_errehmane_hadraoui)){
                                alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.farou9_abd_errehmane_hadraoui);
                                notification_channel_id = "sally_channel_id_athan_farou9_abd_errehmane_hadraoui";
                            }else{
                                if(athanName.equalsIgnoreCase(PreferenceHandler.mohammad_ali_el_banna)){
                                    alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.mohammad_ali_el_banna);
                                    notification_channel_id = "sally_channel_id_athan_mohammad_ali_el_banna";
                                }else{
                                    if(athanName.equalsIgnoreCase(PreferenceHandler.mohammad_khalil_raml)){
                                        alarmSound = Uri.parse("android.resource://"+context.getPackageName()+"/" + R.raw.mohammad_khalil_raml);
                                        notification_channel_id = "sally_channel_id_athan_mohammad_khalil_raml";
                                    }
                                }
                            }
                        }
                    }

                    if(alarmSound == null)
                    {
                        notification_channel_id = "sally_channel_id_athan";
                        alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
                        if(alarmSound == null){
                            alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
                            if(alarmSound == null){
                                alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
                            }
                        }
                    }

                    builder.setSound(alarmSound);
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                {
                    NotificationChannel channel = new NotificationChannel(
                            notification_channel_id,
                            channelName,
                            NotificationManager.IMPORTANCE_HIGH);

                    if(athanType.equalsIgnoreCase(PreferenceHandler.athan))
                    {
                        AudioAttributes audioAttributes = new AudioAttributes.Builder()
                                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                                .build();
                        channel.setSound(alarmSound, audioAttributes);
                        channel.enableLights(true);
                    }

                    if(athanType.equalsIgnoreCase(PreferenceHandler.vibration))
                    {
                        channel.enableVibration(true);
                        channel.setVibrationPattern(new long[] {1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000 ,1000});
                    }

                    builder.setChannelId(notification_channel_id);
                    notificationManager.createNotificationChannel(channel);
                }

                Notification note = null;
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN) {
                    note = builder.build();
                }else{
                    return;
                }

                if(athanType.equalsIgnoreCase(PreferenceHandler.athan))
                {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O)
                    {
                        note.sound = alarmSound;
                        note.defaults |= Notification.DEFAULT_VIBRATE;
                        note.flags |= Notification.FLAG_INSISTENT;
                    }
                }

                notificationManager.notify(1 , note);
            }
        }catch(Exception ex) { }
    }
}
