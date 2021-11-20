package com.sallyprayertimes.widget;

import android.app.PendingIntent;
import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.IBinder;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RemoteViews;
import android.widget.Toast;

import com.sallyprayertimes.MainActivity;
import com.sallyprayertimes.R;
import com.sallyprayertimes.sally.PrayersTimes;
import com.sallyprayertimes.sally.PreferenceHandler;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Calendar;
import java.util.Locale;

public class SmallWidgetProviderService extends Service {

    NumberFormat nf = NumberFormat.getNumberInstance(Locale.US);
    DecimalFormat formatter = (DecimalFormat) nf;

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

        pushWidgetUpdate(this);

        return Service.START_STICKY;
    }

    public void pushWidgetUpdate(Context context)
    {
        try{
            RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.small_widget_layout);

            Intent intent = new Intent(context, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
            remoteViews.setOnClickPendingIntent(R.id.small_widget, pendingIntent);

            remoteViews.setTextViewText(R.id.fajr_label, context.getResources().getString(R.string.fajr));

            if(Calendar.getInstance().get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY){
                remoteViews.setTextViewText(R.id.duhr_label, context.getResources().getString(R.string.jumuah));
            }else{
                remoteViews.setTextViewText(R.id.duhr_label, context.getResources().getString(R.string.duhr));
            }

            remoteViews.setTextViewText(R.id.asr_label, context.getResources().getString(R.string.asr));
            remoteViews.setTextViewText(R.id.maghrib_label, context.getResources().getString(R.string.maghrib));
            remoteViews.setTextViewText(R.id.ishaa_label, context.getResources().getString(R.string.ishaa));

            remoteViews.setTextViewText(R.id.fajr_time, getPrayerFinalTime(PrayersTimes.allPrayrTimesInMinutes[0]));
            remoteViews.setTextViewText(R.id.duhr_time, getPrayerFinalTime(PrayersTimes.allPrayrTimesInMinutes[2]));
            remoteViews.setTextViewText(R.id.asr_time, getPrayerFinalTime(PrayersTimes.allPrayrTimesInMinutes[3]));
            remoteViews.setTextViewText(R.id.maghrib_time, getPrayerFinalTime(PrayersTimes.allPrayrTimesInMinutes[4]));
            remoteViews.setTextViewText(R.id.ishaa_time, getPrayerFinalTime(PrayersTimes.allPrayrTimesInMinutes[5]));

            setActualPrayerTextColor(remoteViews);

            //Toast.makeText(context , "Language: "+PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_LANGUAGE, "en"), Toast.LENGTH_LONG).show();

            ComponentName myWidget = new ComponentName(context, SmallWidgetProvider.class);
            AppWidgetManager manager = AppWidgetManager.getInstance(context);
            manager.updateAppWidget(myWidget, remoteViews);
        }
        catch(Exception ex)
        {
            //Toast.makeText(context, "Widget Error: "+ex.toString(), Toast.LENGTH_LONG).show();
        }
    }

    private void setActualPrayerTextColor(RemoteViews remoteViews){
        remoteViews.setInt(R.id.fajr_label, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.fajr_time, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.duhr_label, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.duhr_time, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.asr_label, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.asr_time, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.maghrib_label, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.maghrib_time, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.ishaa_label, "setTextColor", android.graphics.Color.WHITE);
        remoteViews.setInt(R.id.ishaa_time, "setTextColor", android.graphics.Color.WHITE);

        String nextPrayerColorString = String.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.WIDGET_BACKGROUND_COLOR, "255:13:67:13"));
        String[] myColor = nextPrayerColorString.split(":");
        int backgroundColor = Color.argb(Integer.valueOf(myColor[0]),Integer.valueOf(myColor[1]),Integer.valueOf(myColor[2]),Integer.valueOf(myColor[3]));

        remoteViews.setInt(R.id.small_widget_background_color, "setBackgroundColor", backgroundColor);

        remoteViews.setInt(R.id.fajrLinearLayout, "setBackgroundColor", Color.TRANSPARENT);
        remoteViews.setInt(R.id.duhrLinearLayout, "setBackgroundColor", Color.TRANSPARENT);
        remoteViews.setInt(R.id.asrLinearLayout, "setBackgroundColor", Color.TRANSPARENT);
        remoteViews.setInt(R.id.maghribLinearLayout, "setBackgroundColor", Color.TRANSPARENT);
        remoteViews.setInt(R.id.ishaaLinearLayout, "setBackgroundColor", Color.TRANSPARENT);

        if(PrayersTimes.nextPrayerTimeCode < 6)
        {
            switch (PrayersTimes.nextPrayerTimeCode) {
                case 0:
                    remoteViews.setInt(R.id.fajr_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.fajr_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.fajrLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                case 1:
                    remoteViews.setInt(R.id.duhr_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.duhr_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.duhrLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                case 2:
                    remoteViews.setInt(R.id.duhr_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.duhr_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.duhrLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                case 3:
                    remoteViews.setInt(R.id.asr_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.asr_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.asrLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                case 4:
                    remoteViews.setInt(R.id.maghrib_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.maghrib_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.maghribLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                case 5:
                    remoteViews.setInt(R.id.ishaa_label, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.ishaa_time, "setTextColor", Color.BLACK);
                    remoteViews.setInt(R.id.ishaaLinearLayout, "setBackgroundResource", R.drawable.widget_actual_prayer_background);break;
                default:break;
            }
        }
    }

    public String getPrayerFinalTime(int prayerTotalMinutes) {
        formatter.applyPattern("00");
        int salatHour = prayerTotalMinutes / 60;
        int salatMinutes = prayerTotalMinutes % 60;

        int time12or24 = Integer.valueOf(PreferenceHandler.getSingleton().getValue(PreferenceHandler.PRAYER_TIMES_TYPE_TIME, "24"));

        if (time12or24 == 12 && salatHour > 12) {
            salatHour -= 12;
        }

        return formatter.format(salatHour) + ":" + formatter.format(salatMinutes);
    }

}
