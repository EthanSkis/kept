# Kept for Android

The Android app wraps the web app in `app/` with Capacitor. The web code is the
single source of truth; `npm run build:www` copies it (plus `icons/`) into `www/`,
which Capacitor bundles into the APK.

## Build a test APK

Requirements: Node 22+, JDK 21, and the Android SDK (platform 36, build-tools 36).
Android Studio installs the SDK, or use the command-line tools.

```sh
npm install
echo "sdk.dir=$ANDROID_HOME" > android/local.properties   # once
npm run android:debug
```

The APK lands at `android/app/build/outputs/apk/debug/app-debug.apk`. It is signed
with a debug key: fine for installing on your own phone, not for the Play Store.

To open the project in Android Studio instead: `npm run android:sync`, then
`npx cap open android`.

## After changing the web app

Run `npm run android:sync` (or `android:debug`) so the APK picks up `app/`.

## Native details

- App id `com.keptsociety.app`, name "Kept".
- Launcher icons and splash screens are the pillars mark on `#F4F3F1`.
- Edge-to-edge: the SystemBars plugin hands the status bar inset to the page
  through `env(safe-area-inset-*)`, which the app already uses. Status bar icons
  switch to light on the night screens (`app/index.html`, in `render`).
- The web service worker is skipped inside the app; Capacitor serves files locally.

## Known gaps in this first build

- Voice journaling: Android's WebView has no speech recognition, so the journal
  falls back to typing. Needs a native speech plugin.
- "Share image" on the weekly card: WebView ignores web downloads. Needs the
  Capacitor Share or Filesystem plugin.
- Play Store release: needs an upload keystore, a release build (`bundleRelease`),
  and Google Play billing for the membership.
