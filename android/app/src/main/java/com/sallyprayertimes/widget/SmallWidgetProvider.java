package com.sallyprayertimes.widget;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;

public class SmallWidgetProvider extends AppWidgetProvider {

    public static Boolean isEnabled = false;

    @Override
    public void onUpdate(final Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        isEnabled = true;
        context.startService(new Intent(context, SmallWidgetProviderService.class));
    }

    @Override
    public void onEnabled(Context context) {
        isEnabled = true;
        context.startService(new Intent(context, SmallWidgetProviderService.class));
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds){
        isEnabled = false;
    }

}

