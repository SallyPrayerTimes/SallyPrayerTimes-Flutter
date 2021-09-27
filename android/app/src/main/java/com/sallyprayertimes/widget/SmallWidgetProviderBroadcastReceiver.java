package com.sallyprayertimes.widget;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class SmallWidgetProviderBroadcastReceiver extends BroadcastReceiver{

    @Override
    public void onReceive(Context context, Intent intent) {
        context.startService(new Intent(context, SmallWidgetProviderService.class));
    }

}

