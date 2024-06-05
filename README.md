# dominion_companion

Shuffle your Dominion decks

## Updating the version
change the version in the pubspec.yaml file
change the version in the local.properties file

## Check the card names and images
in the main.dart adjust
await settingsService.initializeApp();
to
await settingsService.initializeApp(checkCardNamesAndImages: true);

## Create release
Build -> Flutter -> Build APK
build\app\outputs\flutter-apk\app-release.apk

## TODO
Add a way to select which versions of the sets to use
Create jsons for the older sets
Test if the names are correct
