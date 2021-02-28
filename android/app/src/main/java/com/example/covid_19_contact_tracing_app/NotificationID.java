package com.example.covid_19_contact_tracing_app;

import java.util.concurrent.atomic.AtomicInteger;


/**
 * Credit to Ted Hopp:
 * https://stackoverflow.com/questions/25713157/generate-int-unique-id-as-android-notification-id
 */
public class NotificationID {
    private final static AtomicInteger c = new AtomicInteger(0);
    public static int getID() {
        return c.incrementAndGet();
    }
}
