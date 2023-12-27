# haltia_test

The task was to use flutter_chat_ui, whisper.cpp and some storage.

# Disclaimer

I use an old MacBook and that's why can't use the latest versions of Xcode, Flutter, Gradle etc. Hope this will not make problems on the latest ones. Currently I have Dart 3.0.6 with Flutter 3.10.6.

# Project setup

The usual steps 

`flutter pub get`

`dart run build_runner build`

You may also want to change the used Whisper model in 8th line of `WhisperTranscribeService`

# Whisper.cpp

I tried to use packages from `pub.dev` but they use the old version of whisper.cpp and that's why are toooo slow. 
So I used `whisper_flutter_plus` as a base and altered it to use with newer whisper.cpp (which is charged with CoreML). I wanted to do this inside the package to then make a PR but the setup requires some complex setup of Xcode and I didn't find a quick way to pack it back to the package. That's why a part of changed `whisper_flutter_plus` is embedded into the project. 

# Storage

I decided to use Drift as as storage because it is a reliable reactive lib on top of SQLite. But the assumption is made that we will use only `TextMessage`s. Otherwise it will require much more code. And maybe nosql solution will be better here.

# Chat

Nothing to say here. I created a custom bottom input widget which support speech recognition 