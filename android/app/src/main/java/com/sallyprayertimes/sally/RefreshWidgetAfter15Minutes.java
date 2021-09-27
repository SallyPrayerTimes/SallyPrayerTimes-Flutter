package com.sallyprayertimes.sally;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.PowerManager;

import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

public class RefreshWidgetAfter15Minutes  extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        PowerManager powerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        PowerManager.WakeLock wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::MyWakelockTag1");
        wakeLock.acquire(10000);

        if(SmallWidgetProvider.isEnabled){
            context.startService(new Intent(context, SmallWidgetProviderService.class));
        }
    }
}

