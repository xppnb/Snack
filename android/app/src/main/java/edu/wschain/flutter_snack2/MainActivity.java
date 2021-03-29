package edu.wschain.flutter_snack2;


import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private SharedPreferences sharedPreferences;
    private SharedPreferences.Editor editor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sharedPreferences = getSharedPreferences("f",MODE_PRIVATE);
        editor = sharedPreferences.edit();
        new MethodChannel(getFlutterView(),"android").setMethodCallHandler(new MethodChannel.MethodCallHandler() {

            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                switch (call.method){
                    case "getSp":
                        String data = sharedPreferences.getString("data", null);
                        result.success(data);
                        break;
                    case "setSp":
                        editor.putString("data",call.arguments.toString());
                        editor.apply();
                        break;
                }
            }
        });
    }
}
