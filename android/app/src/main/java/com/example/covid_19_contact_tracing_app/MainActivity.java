package com.example.covid_19_contact_tracing_app;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.messages.Message;
import com.google.android.gms.nearby.messages.MessageListener;
import com.google.android.gms.nearby.messages.PublishOptions;
import com.google.android.gms.nearby.messages.Strategy;
import com.google.android.gms.nearby.messages.SubscribeOptions;
import com.google.android.gms.tasks.Task;

import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;

// This class represents the Android version of the app
// It handles the nearby messages business logic
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "nearby-message-api";
    private static final String TAG = "Nearby Message API";
    private static final String NEARBY_CHANNEL_ID = "Nearby Notification";
    private MethodChannel methodChannel;
    private MessageListener mMessageListener;
    private Message mActiveMessage;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        //set up method channel listener
        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "toggleContactTracing":
                            toggleContactTracing(call.argument("shouldTrace"), result);
                            break;
                        case "publish":
                            publish(call.argument("message"), result);
                            break;
                        case "notifyContactTracing":
                            notifyContactTracing(call.argument("message"));
                            result.success(null);
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

        //For analytics purposes
        AppCenter.start(getApplication(), "0087a3d1-1804-417f-8387-e3601e173aaf",
                Analytics.class, Crashes.class);

        createNotificationChannel();

        //when a signal is received
        mMessageListener = new MessageListener() {
            @Override
            public void onFound(Message message) {
                Log.d(TAG, "Found message: " + message);
                String messageString = new String(message.getContent(), StandardCharsets.UTF_8);
                try {
                    JSONObject messageJson = new JSONObject(messageString);
                    if (messageJson.getBoolean("sick")) {
                        String contentText;
                        if (messageJson.getString("reason").equals("SickReason.SYMPTOMS")) {
                            contentText = "Somebody near you has symptoms of Coronavirus";
                        } else {
                            contentText = "Somebody near you has tested positive for Coronavirus";
                        }
                        //notify user
                        displayNotification("COVID Proximity Alert", contentText);
                    }

                    //report contact to cross-platform layer
                    methodChannel.invokeMethod("receivedMessage", new HashMap<String, String>() {{
                        put("message", messageString);
                    }});
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onLost(Message message) {
                Log.d(TAG, "Lost sight of message: " + new String(message.getContent()));
            }
        };
    }

    //credit to Android docs: https://developer.android.com/training/notify-user/channels
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(NEARBY_CHANNEL_ID, "Nearby Messages", importance);
            channel.setDescription("");

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    //when an cloud message reports an exposure
    private void notifyContactTracing(String contentText) {
        displayNotification("Contact Tracing Alert", contentText);
    }

    private void displayNotification(String contentTitle, String contentText) {
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(MainActivity.this, NEARBY_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(contentTitle)
                .setContentText(contentText)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(contentText))
                .setPriority(NotificationCompat.PRIORITY_HIGH);
        NotificationManagerCompat manager = NotificationManagerCompat.from(MainActivity.this);
        manager.notify(NotificationID.getID(), notificationBuilder.build());
    }

    //when the app is in the foreground
    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "starting");
        SharedPreferences prefs = getContext().getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        boolean contactTracePref = prefs.getBoolean("flutter." + "contactTracing", false);
        Log.d(TAG, "" + contactTracePref);
        //if contact tracing is enabled, listen for signals and broadcast the current message
        if (contactTracePref) {
            Log.d(TAG, "subscribing");
            subscribe();
            resumeCurrentMessage();
        }
    }

    //when the user taps the contact tracing toggle button
    //when enabled, the device subscribes and listens for signals
    private void toggleContactTracing(boolean shouldScan, MethodChannel.Result result) {
        if (shouldScan) {
            subscribe()
                    .addOnSuccessListener(aVoid -> result.success(null))
                    .addOnFailureListener(e -> result.error("SUBSCRIBE", e.getMessage(), null));
        } else {
            unsubscribe()
                    .addOnSuccessListener(aVoid -> result.success(null))
                    .addOnFailureListener(e -> result.error("UNSUBSCRIBE", e.getMessage(), null));
        }
    }

    //listen to signals
    //uses the play-services-nearby library
    private Task<Void> subscribe() {
        SubscribeOptions options = new SubscribeOptions.Builder()
                .setStrategy(Strategy.DEFAULT)
                .build();
        return Nearby.getMessagesClient(this).subscribe(mMessageListener, options);
    }

    //stop listening to signals
    //uses the play-services-nearby library
    private Task<Void> unsubscribe() {
        Log.i(TAG, "Unsubscribing.");
        return Nearby.getMessagesClient(this).unsubscribe(mMessageListener);
    }

    //broadcast a message
    //uses the play-services-nearby library
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

    //resume broadcasting the current message
    //uses the play-services-nearby library
    private void resumeCurrentMessage() {
        if (mActiveMessage != null) {
            Strategy publishStrategy = new Strategy.Builder()
                    .setTtlSeconds(Strategy.TTL_SECONDS_MAX)
                    .setDistanceType(Strategy.DISTANCE_TYPE_EARSHOT)
                    .build();
            PublishOptions publishOptions = new PublishOptions.Builder()
                    .setStrategy(publishStrategy)
                    .build();
            Nearby.getMessagesClient(this).publish(mActiveMessage, publishOptions);
        }
    }

    //stop broadcasting the current message
    //uses the play-services-nearby library
    private void unpublish() {
        Log.i(TAG, "Unpublishing.");
        if (mActiveMessage != null) {
            Nearby.getMessagesClient(this).unpublish(mActiveMessage);
        }
    }

    //stop listening and broadcasting when the app is not in the foreground
    @Override
    protected void onStop() {
        unsubscribe();
        unpublish();
        super.onStop();
    }
}
