# CHANGELOG

## 1.0.1
* Added padding to CPXSurveyCards
* Added surveys loading to initState

## 1.0.0 - Breaking
* Added easiest showCPXBrowserDialog
* Building with current flutter version `3.24.3`
* Update `sdk` package version to `'>=3.5.0 <4.0.0`
* Update `http` package version to `^1.2.2`
* Update `json_annotation` package version to `^4.9.0`
* Update `json_serializable` package version to `^6.6.1`
* Update `webview_flutter` package version to `^4.9.0`
* Update `build_runner` package version to `^2.4.12`
* Added Copyright 
* Refactoring for DRY Principle 
* Refactored Enumerations
* Fixed Deprecated imperative apply of Flutter's Gradle plugins

## 0.4.5
* Update deprecated Flutter syntax
* Update deprecated primary parameter
* Fixed typo

## 0.4.4
* Update Android gradle version, target and compile SDK to 31
* Update `dart` sdk version to `>=2.18`
* Update `http` package version to `^1.1.0`
* Update `json_annotation` package version to `^4.7.0`
* Update `json_serializable` package version to `^6.6.1 `
* Update `webview_flutter` package version to `^4.2.2`
  * Change WebView to WebViewWidget and implement WebViewController
  * Delete Settings Tab from Browser View 
  * Add back, reload and opinion button onWebResourceError websites

## 0.4.3
* Fix `CPXSurveyCard` payoutOriginal null pointer error
* Update `webview_flutter` package version to `^3.0.4`
* Update `json_annotation` package version to `^4.5.0`

## 0.4.2

* Add customizable `noSurveyWidget` and `hideIfEmpty` properties to `CPXSurveyCards`
* Fix `CPXSurveyCard` state refresh
* Update `http` package version to `^0.13.4`
* Update `webview_flutter` package version to `^3.0.2`

## 0.4.1

* Update `webview_flutter` package version to `^3.0.1`
* Fix `survey card background`
* Delete `pubspec.lock` for SDK (recommended)

## 0.4.0 - Null Safety

* Migrate package to `Null Safety`
* Migrate app to `Null Safety`

## 0.3.1

* Fix `survey card colors`

## 0.3.0

* Add original payout logic
* Add landscape layout
* Add `changelog.md`
* Add survey browser error handling
* Add `browser state listener`
* Add app icon for demo app
* Improved logs
* Optimized CPX import
* Optimized code quality

## 0.2.0

* Add `survey cards`

## 0.1.0

* Add `cpx browser view`
* Add `cpx widget overlay`
* Add public functions
* Add logging
* Add `demo app`