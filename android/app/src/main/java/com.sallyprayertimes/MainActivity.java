package com.sallyprayertimes;

import android.content.Intent;
import android.content.res.Configuration;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.sallyprayertimes.sally.AthanService;
import com.sallyprayertimes.sally.PrayersTimes;
import com.sallyprayertimes.sally.PreferenceHandler;
import com.sallyprayertimes.widget.SmallWidgetProvider;
import com.sallyprayertimes.widget.SmallWidgetProviderService;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "com.sallyprayertimes/sallyprayertimeschannel";
    private Intent serviceIntent;

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        serviceIntent = new Intent(MainActivity.this, AthanService.class);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if(call.method.equals("startService")){
                    startService(serviceIntent);
                }else if(call.method.equals("getPrayersTimes")){
                    final List<String> list = new ArrayList<>();
                    list.add(String.valueOf(PrayersTimes.nextPrayerTimeCode));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[0]));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[1]));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[2]));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[3]));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[4]));
                    list.add(String.valueOf(PrayersTimes.allPrayrTimesInMinutes[5]));
                    result.success(list);
                }else if(call.method.equals("refreshWidget")){
                    if(SmallWidgetProvider.isEnabled){
                        Toast.makeText(MainActivity.this, "refreshWidget", Toast.LENGTH_LONG).show();
                        startService(new Intent(MainActivity.this, SmallWidgetProviderService.class));
                    }
                }
              }
            }
        );
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

}
