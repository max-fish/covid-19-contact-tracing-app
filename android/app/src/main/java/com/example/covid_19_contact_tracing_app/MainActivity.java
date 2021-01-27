package com.example.covid_19_contact_tracing_app;

import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.messages.Message;
import com.google.android.gms.nearby.messages.MessageListener;
import com.google.android.gms.nearby.messages.PublishOptions;
import com.google.android.gms.nearby.messages.Strategy;
import com.google.android.gms.nearby.messages.SubscribeOptions;
import com.google.android.gms.tasks.Task;


import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "nearby-message-api";
    private static final String TAG = "Nearby Message API";
    private MethodChannel methodChannel;
    private MessageListener mMessageListener;
    private Message mActiveMessage;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);

        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "toggleContactTracing":
                            toggleContactTracing(call.argument("shouldTrace"), result);
                            break;
                        case "publish":
                            publish(call.argument("message"), result);
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
                Log.d(TAG, "Found message: " + message);
                methodChannel.invokeMethod("receivedMessage", new HashMap<String, String>() {{
                    put("message", message.getContent().toString());
                }});
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
        Log.d(TAG, "starting");
        SharedPreferences prefs = getContext().getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        boolean contactTracePref = prefs.getBoolean("flutter." + "contactTracing", false);
        Log.d(TAG, "" + contactTracePref);
        if (contactTracePref) {
            subscribe();
        }
    }


    private void toggleContactTracing(boolean shouldScan, MethodChannel.Result result) {
        if (shouldScan) {
            subscribe()
                    .addOnFailureListener(e -> result.error("SUBSCRIBE", e.getMessage(), null));
            backgroundSubscribe()
                    .addOnSuccessListener(aVoid -> result.success(null))
                    .addOnFailureListener(e -> result.error("BACKGROUND_SUBSCRIBE", e.getMessage(), null));
        } else {
            unsubscribe()
                    .addOnFailureListener(e -> result.error("UNSUBSCRIBE", e.getMessage(), null));
            backgroundUnsubscribe()
                    .addOnSuccessListener(aVoid -> result.success(null))
                    .addOnFailureListener(e -> result.error("BACKGROUND_UNSUBSCRIBE", e.getMessage(), null));
        }
    }

    private Task<Void> subscribe() {
        SubscribeOptions options = new SubscribeOptions.Builder()
                .setStrategy(Strategy.BLE_ONLY)
                .build();
        return Nearby.getMessagesClient(this).subscribe(mMessageListener, options);
    }

    private Task<Void> backgroundSubscribe() {
        SubscribeOptions options = new SubscribeOptions.Builder()
                .setStrategy(Strategy.BLE_ONLY)
                .build();
        return Nearby.getMessagesClient(this).subscribe(getPendingIntent(), options);
    }


    private Task<Void> unsubscribe() {
        Log.i(TAG, "Unsubscribing.");
        return Nearby.getMessagesClient(this).unsubscribe(mMessageListener);
    }

    private Task<Void> backgroundUnsubscribe() {
        return Nearby.getMessagesClient(MainActivity.this).unsubscribe(getPendingIntent());
    }

    private PendingIntent getPendingIntent() {
        return PendingIntent.getBroadcast(this, 0, new Intent(this, BeaconMessageReceiver.class),
                PendingIntent.FLAG_UPDATE_CURRENT);
    }

    private void publish(String message, MethodChannel.Result result) {
        Log.i(TAG, "Publishing message: " + message);
        mActiveMessage = new Message(message.getBytes());
        Strategy publishStrategy = new Strategy.Builder()
                .setTtlSeconds(Strategy.TTL_SECONDS_MAX)
                .setDistanceType(Strategy.DISTANCE_TYPE_EARSHOT)
                .build();
        PublishOptions publishOptions = new PublishOptions.Builder()
                .setStrategy(publishStrategy)
                .build();
        Nearby.getMessagesClient(this).publish(mActiveMessage, publishOptions)
                .addOnSuccessListener(aVoid -> result.success(null))
                .addOnFailureListener(e -> result.error("PUBLISH", e.getMessage(), null));
    }

    private void unpublish() {
        Log.i(TAG, "Unpublishing.");
        if (mActiveMessage != null) {
            Nearby.getMessagesClient(this).unpublish(mActiveMessage);
            mActiveMessage = null;
        }
    }

    @Override
    protected void onStop() {
        unsubscribe();
        super.onStop();
    }
}
