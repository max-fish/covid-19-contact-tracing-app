# Walkdown

An app designed to make users aware of their potential exposure to COVID-19.

## Setting up the project
Note: If you would like to run this app for Android, you can skip this section! Check out running the app for Android below.

If you would like to run this app for iOS, setup needs to be done with an Apple machine that has Xcode.


1. Install the Flutter SDK from here: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
2. Make sure to set the PATH variable as mentioned to access the Flutter command-line interface.
3. Run `flutter doctor` in the command line to make sure the framework is up to date.
4. Navigate to the root directly of the project and run `flutter create .`
to generate the necessary iOS and Android build files.
(The period after `create` is very important! Without it, a new Flutter
project will be created inside the existing one.)
5. Run `flutter packages get` to get the necessary dependencies.

## Running tests
1. Navigate to the root directly of this project in the command line.
2. Run `flutter test` for unit and widget testing.
3. To run integration testing,
   1. [Configure your mobile device for testing](#configure-a-device-for-testing)
   2. run `flutter drive --target=test_driver/app.dart`


## Running the app

###  For Android:

1. Go to this link: [https://install.appcenter.ms/orgs/walkdown-app-testers/apps/walkdown/distribution_groups/beta%20testers](https://install.appcenter.ms/orgs/walkdown-app-testers/apps/walkdown/distribution_groups/beta%20testers) on an Android device.
2. Alternatively, you can scan this QR code:

<img src="android/app/release/frame.png" width="150" height="150">

3. Follow the instructions on that page to install the app.

When installing, your phone will you get a Play Store alert telling
you that the developer is not trusted. This is normal behavior,
since the app is not meant to be on the Play Store.

###  For iOS:
Unfortunately, due to Apple's very strict distribution guidelines,
 the app could not be published.

However, it is possible to run a debug build.

1. [Configure your iOS device for testing](#ios)
2. Open the ios/Runner.xcworkspace folder in Xcode.
3. Make sure your iOS device is connected, on, and unlocked.
4. Press the play button in the top menu bar of Xcode.


## Configure a device for testing
###  Android
1. On the device, go to settings, and check if you have developer
options at the bottom.
2. If you don't,
   1. tap "About phone" or "About device" in the settings menu
   2. tap "Software Information"
   3. tap the build number seven times.
3. Once developer mode has been enabled, go to developer options
and enable USB debugging.
4. Connect the phone to your machine via USB cable. Make sure the device trusts your
computer if that is necessary.
5. Check if the computer sees your device by running `flutter devices`

### iOS
1. Open iOS/Runner.xcworkspace file in Xcode.
2. Connect your device to your Mac via USB cable.
3. At the top menu bar of Xcode, there is button "Runner > *some iphone*"
4. Tap on it, and select your device.
5. In the file directory on the left side, click on the top-level Runner folder.
6. Click on Runner in the "TARGETS" section in the central part of Xcode.
7. Click on Signing and Capabilities
8. Click on either All or Debug
9. Make sure "Automatically manage signing" is turned on.
10. For team, open the menu, and click on "Add an account..."
11. Add your Apple ID account. If you don't have an Apple ID account,
please make one here: [Create Apple ID](https://appleid.apple.com/cgi-bin/WebObjects/MyAppleId.woa/wa/createAppleId?localang=GB-EN&app_id=2083&returnURL=https%3A//secure4.store.apple.com/uk/shop/signIn%3Fc%3DaHR0cHM6Ly93d3cuYXBwbGUuY29tL3VrL3Nob3AvYmFnfDFhb3MyZDU3OTMzMWMyYjA4NDE2M2M4OTU4ZDEyNTJjNmMwZmMzNGMxMTY5%26r%3DSCDHYHP7CY4H9XK2H%26s%3DaHR0cHM6Ly93d3cuYXBwbGUuY29tL3VrL3Nob3AvYmFnfDFhb3MyZDU3OTMzMWMyYjA4NDE2M2M4OTU4ZDEyNTJjNmMwZmMzNGMxMTY5)
12. Once your Apple ID account is added to Xcode, select in the team menu.
13. When you select your team, Xcode it will you tell you that it
"Failed to register bundle identifier", because
"No profiles for 'com.example.covid19ContactTracingApp' were found".
14. To fix this, think of any unique bundle identifier and replace the
old one.
15. Then click try again button below the "Failed to register bundle
identifier" error.
16. If you get a message saying "codesign wants to access key "access"
in your keychain", type in the password you use to log on your Mac.
17. Then tap "Always Allow".
18. Make sure your iOS device is connected, on, and unlocked.
19. In the top menu bar of Xcode, press the play button.
20. The first time you run the app, Xcode will fail due to security.
21. To fix this, go to settings -> general -> device management on your
iOS device.
22. Tap Trust *Your Developer Name*





