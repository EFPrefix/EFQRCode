# Change Log

## [6.2.2](https://github.com/EFPrefix/EFQRCode/releases/tag/6.2.2) (2023-03-06)

#### Fix

- Fix compiler error when compiled using Xcode 14.3 [#153](https://github.com/EFPrefix/EFQRCode/pull/153)

## [6.2.1](https://github.com/EFPrefix/EFQRCode/releases/tag/6.2.1) (2022-03-03)

#### Fix

- Fix `EFCirclePointStyle` to respect `isTimingPointStyled` settings.

---

## [6.2.0](https://github.com/EFPrefix/EFQRCode/releases/tag/6.2.0) (2021-11-21)

#### Add

- Add `EFPointStyle` protocol to allow customizing foreground point style.

#### Deprecate

- `EFPointShape` is deprecated. Use `EFPointStyle` instead.

---

## [6.1.0](https://github.com/EFPrefix/EFQRCode/releases/tag/6.1.0) (2021-04-08)

#### Add

- Supports chaining `EFQRCodeGenerator` configuration methods.
- `EFQRCodeGenerator` properties are now public.
- `EFQRCodeGenerator.clearCache` can be used to free up memories used for caching results.
- English documentation is now available through Xcode quick help.
- Swift: `EFWatermarkMode.rectForWatermark(ofSize:inCanvasOfSize:)` can be used to calculate the frame for watermark image in a canvas.
- Objective-C: New tests to ensure APIs are available in Objective-C.

#### Change

- Renamed `EFQRCodeGenerator` configuration methods to be more consistent.
   - Renamed `EFQRCode` and reordered convenience generate function arguments to be consistent with generator methods.
- `EFQRCodeGenerator` now caches more generated contents to improve performance.
- `EFQRCodeRecognizer` expects non-nil image and returns non-nil array of results. The returned array may still be empty.
- `EFIntSize` is now an immutable, final class.
- Renamed `CGColor` extensions `white` and `black` to omit first argument label.
- Objective-C: `EFQRCodeGenerator` and `EFQRCodeRecognizer` is now fully available to configure/use in Objective-C.

#### Deprecate

- `EFQRCodeMode.none` is now deprecated. Use `nil` and `EFQRCodeMode?` instead.

#### Remove

- `EFUIntPixel` is no longer a part of the public interface.
- GIF generation no longer takes `pathToSave` parameter.
- Objective-C: `EFQRCode` is no longer available in Objective-C. Use `EFQRCodeGenerator` and `EFQRCodeRecognizer` instead.

---

## [6.0.0](https://github.com/EFPrefix/EFQRCode/releases/tag/6.0.0) (2020-11-04)

#### Add

- Add support to compile for macOS 10.10 using CocoaPods.

#### Changed

- `swift_qrcodejs` is now conditional dependency with Swift Package Manager 5.3+.

#### Remove

- Drop iOS 8 support from CocoaPods with Xcode 12 [#101](https://github.com/EFPrefix/EFQRCode/pull/101);
- Remove `Core` and `watchOS` sub-specs [#100](https://github.com/EFPrefix/EFQRCode/issues/100).

---

## [5.1.9](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.9) (2020-11-04)

#### Add

- Add Playgrounds with usage example [#98](https://github.com/EFPrefix/EFQRCode/pull/98).

#### Fix

- Fix SwiftPM syntax in README [#99](https://github.com/EFPrefix/EFQRCode/pull/99);
- Fix GIF frame delay time setting [#104](https://github.com/EFPrefix/EFQRCode/issues/104);
- Now generates QRCode with correct, specified content encoding on watchOS;
- Pin `swift_qrcodejs` to 1.2.0, up to next minor [#102](https://github.com/EFPrefix/EFQRCode/pull/102).

---

## [5.1.8](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.8) (2020-09-18)

#### Fix

- Fix issue [#95](https://github.com/EFPrefix/EFQRCode/issues/95)

---

## [5.1.7](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.7) (2020-09-14)

#### Add

- Add a contentEncoding parameter [#90](https://github.com/EFPrefix/EFQRCode/pull/90);
- Add compatibility with Catalyst dependencies [#88](https://github.com/EFPrefix/EFQRCode/pull/88).

#### Fix

- Update `swift_qrcodejs` to 1.1.4.

---

## [5.1.6](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.6) (2019-11-21)

#### Fix

- Remove dependency `EFFoundation`.

---

## [5.1.5](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.5) (2019-11-20)

#### Fix

- Fix podspec.

---

## [5.1.4](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.4) (2019-11-19)

#### Fix

- Fix issue [#83](https://github.com/EFPrefix/EFQRCode/issues/83).

---

## [5.1.3](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.3) (2019-10-13)

#### Fix

- Fix conflicts with `SwifterSwift`.

---

## [5.1.2](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.2) (2019-10-10)

#### Fix

- Fix `ciColor()` in extension of UIColor.

---

## [5.1.1](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.1) (2019-10-09)

#### Add

- Add subspec `watchOS`.

#### Change

- Make extensions internal;
- Update swift package;
- Update gif generation;
- Add dependency on `EFFoundation`.

---

## [5.1.0](https://github.com/EFPrefix/EFQRCode/releases/tag/5.1.0) (2019-09-17)

#### Add

Add parameter `ignoreTiming`.

---

## [5.0.1](https://github.com/EFPrefix/EFQRCode/releases/tag/5.0.1) (2019-09-11)

#### Fix

Fix issue [#65](https://github.com/EFPrefix/EFQRCode/issues/65).

---

## [5.0.0](https://github.com/EFPrefix/EFQRCode/releases/tag/5.0.0) (2019-03-31)

#### Add

* Add documentation for some extension methods.

#### Change

* Update to Swift 5;
* Improve internal implementation to allocate memory needed all at once.

#### Remove

* Remove Microsoft App Center SDK from examples.

---

## [4.5.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.5.0) (2019-01-13)

#### Add

* Add point style `diamond`;
* Add `Objective-C` support;
* Add `accessibilityIgnoresInvertColors` support.

---

## [4.4.2](https://github.com/EFPrefix/EFQRCode/releases/tag/4.4.2) (2018-11-14)

#### Add

* Add parameters to meet the needs of [#50](https://github.com/EFPrefix/EFQRCode/issues/50).

---

## [4.4.1](https://github.com/EFPrefix/EFQRCode/releases/tag/4.4.1) (2018-11-08)

#### Add

* Add dependency on [swift_qrcodejs](https://github.com/ApolloZhu/swift_qrcodejs).

---

## [4.4.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.4.0) (2018-11-05)

#### Add

* Upgrade to Swift 4.2.

---

## [4.3.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.3.0) (2018-09-14)

#### Fix

* Update version.

---

## [4.2.2](https://github.com/EFPrefix/EFQRCode/releases/tag/4.2.2) (2018-01-09)

#### Add

* Add multiple threads support for GIF.

---

## [4.2.1](https://github.com/EFPrefix/EFQRCode/releases/tag/4.2.1) (2018-01-09)

#### Fix

* Add border for watchOS.

---

## [4.2.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.2.0) (2018-01-03)

#### Add

* Support watchOS;
* Add example for watchOS.

---

## [4.1.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.1.0) (2017-11-01)

#### Add

* Add GIF support.

---

## [4.0.0](https://github.com/EFPrefix/EFQRCode/releases/tag/4.0.0) (2017-09-21)

#### Add

* Update for Swift 4.

---

## [1.2.7](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.7) (2017-07-26)

#### Add

* Add support for Objective-C.

---

## [1.2.6](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.6) (2017-07-25)

#### Fix

* Fix issue [#21](https://github.com/EFPrefix/EFQRCode/issues/21).

---

## [1.2.5](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.5) (2017-05-24)

#### Add

* Add binarization;
* Add point shape.

#### Fix

* Fix issue [#11](https://github.com/EFPrefix/EFQRCode/issues/11).

---

## [1.2.4](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.4) (2017-04-23)

#### Add

* Add example for macOS;
* Add example for tvOS.

#### Fix

* Fix iOS 8 error.

---

## [1.2.3](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.3) (2017-04-18)

#### Fix

* Fix CocoaPods platform.

---

## [1.2.2](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.2) (2017-04-17)

#### Add

* Support Carthage;
* Support tvOS;
* Support macOS.

---

## [1.2.1](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.1) (2017-04-11)

#### Add

* Change parameter size and iconSize from CGFloat to EFIntSize;
* Remove UIKit.

#### Fix

* Increase efficiency;
* Fix issue [#4](https://github.com/EFPrefix/EFQRCode/issues/4).

---

## [1.2.0](https://github.com/EFPrefix/EFQRCode/releases/tag/1.2.0) (2017-04-01)

#### Add

* Add parameter foregroundPointOffset;
* Add parameter allowTransparent.

#### Fix

* Make it more Object-oriented;
* Make it faster and more effective;
* Improve demo;
* Improve documentation.

---

## [1.1.1](https://github.com/EFPrefix/EFQRCode/releases/tag/1.1.1) (2017-02-15)

#### Fix

* Detail modification;
* Improve documentation.

---

## [1.1.0](https://github.com/EFPrefix/EFQRCode/releases/tag/1.1.0) (2017-02-10)

#### Add

* Add watermark image and some other feature.

#### Fix

* Remove UIImage extension;
* Improve documentation.

---

## [1.0.0](https://github.com/EFPrefix/EFQRCode/releases/tag/1.0.0) (2017-01-24)

First public release.
