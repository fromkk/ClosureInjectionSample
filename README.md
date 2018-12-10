# ClosureInjection sample

![Swift badge](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat) ![Swift badge](https://img.shields.io/badge/iOS-11-F16D39.svg?style=flat)

---

# What

Sample code for `Closure Injection`

# Features

- Choose your photos and videos from camera roll and upload to Firebase(Firestore and Storage)

# How to build

Clone repository

```sh
git clone git@github.com:fromkk/ClosureInjectionSample.git
```


Change directory

```sh
cd ./ClosureInjectionSample
```

Load libraries

```bash
carthage build --platform ios
pod update
```

Add GoogleService-Info.plist

```bash
mv /path/from/GoogleService-Info.plist ./FirebaseUploaderSample/Resources/
```

Open and build

```bash
open ./FirebaseUploaderSample.xcworkspace
```

**Build and Run!**
