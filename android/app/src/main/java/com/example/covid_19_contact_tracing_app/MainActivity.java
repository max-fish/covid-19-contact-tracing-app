package com.example.covid_19_contact_tracing_app;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.messages.Message;
import com.google.android.gms.nearby.messages.MessageListener;
import com.google.android.gms.nearby.messages.Strategy;
import com.google.android.gms.nearby.messages.SubscribeOptions;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "nearby-message-api";
    private static final String TAG = "Nearby Message API";
    private MessageListener mMessageListener;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method){
                                case "subscribe":
                                    subscribe();
                                    break;
                                case "backgroundSubscribe":
                                    backgroundSubscribe();
                                    break;
                                case "unsubscribe":
                                    unsubscribe();
                                    break;
                                case "backgroundUnsubscribe":
                                    backgroundUnsubscribe();
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mMessageListener = new MessageListener() {
            @Override
            public void onFound(Message message) {
                Log.d(TAG, "Found message: " + new String(message.getContent()));
            }

            @Override
            public void onLost(Message message) {
                Log.d(TAG, "Lost sight of message: " + new String(message.getContent()));
            }
        };
    }

    @Override
    protected void onStart() {
        super.onStart();
        subscribe();
        backgroundSubscribe();
    }

    private void subscribe() {
        Log.i(TAG, "Subscribing.");
        SubscribeOptions options = new SubscribeOptions.Builder()
                .setStrategy(Strategy.BLE_ONLY)
                .build();
        Nearby.getMessagesClient(this)
                .subscribe(mMessageListener, options);
    }

    private void backgroundSubscribe() {
        SubscribeOptions options = new SubscribeOptions.Builder()
                .setStrategy(Strategy.BLE_ONLY)
                .build();
        Nearby.getMessagesClient(this).subscribe(getPendingIntent(), options);
    }


    private void unsubscribe() {
        Log.i(TAG, "Unsubscribing.");
        Nearby.getMessagesClient(this).unsubscribe(mMessageListener);
    }

    private void backgroundUnsubscribe() {
        Nearby.getMessagesClient(this).unsubscribe(getPendingIntent());
    }

    private PendingIntent getPendingIntent() {
        return PendingIntent.getBroadcast(this, 0, new Intent(this, BeaconMessageReceiver.class),
                PendingIntent.FLAG_UPDATE_CURRENT);
    }

    @Override
    protected void onStop() {
        unsubscribe();
        super.onStop();
    }
}
