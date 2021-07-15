fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios local
```
fastlane ios local
```
Update dependences
### ios update_build_number
```
fastlane ios update_build_number
```
Update build number
### ios build
```
fastlane ios build
```
Make a new build
### ios upload_testflight
```
fastlane ios upload_testflight
```
Upload to testflight alpha and beta test

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
