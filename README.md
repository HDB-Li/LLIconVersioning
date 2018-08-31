# LLIconVersioning

A script that automatically creates an appIcon with debugging information

[![Platform](https://img.shields.io/badge/Platform-Xcode.svg)](https://img.shields.io/badge/Platform-Xcode.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-shell-yellow.svg)](https://img.shields.io/badge/Language-shell-yellow.svg)
[![Twitter](https://img.shields.io/badge/twitter-@HdbLi-1DA1F2.svg)](https://twitter.com/HdbLi)

## Introduction

[点击查看中文简介](https://github.com/HDB-Li/LLIconVersioning/blob/master/README-cn.md)

LLIconVersioning is a script that automatically creates an appIcon with debugging information. The integration script in run script can automatically create an icon with version information each time you build or archive, also you can use it to automatically manage build number.

## Rendering

[![Rendering](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Rendering.png)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Rendering.png)

`1.0.0` is app version, `9` is build number, `Debug` is environment name.

## What can you do with LLIconVersioning?

It's a script which can help you manager icon, you can more easily see the app version infos.

And you can also automatic management build number, such as `1` increase to `2`, or `1.0.0` increase to `1.0.1`, or you can use the date to be the build number such as `201808311200`.

`LLIconVersioning` is modified according to [`IconOverlaying`](https://github.com/krzysztofzablocki/IconOverlaying), but `IconOverlaying` is no longer support Xcode 9 and iOS 11. 

Although `LLIconVersioning` is modified according to `IconOverlaying`, but the central idea is different. 

`LLIconVersioning` is modified your `project.pbxproj`, and set your `ASSETCATALOG_COMPILER_APPICON_NAME` from `appIcon` to `appIcon-Debug` in debug environment, it means your app will build with `appIcon-Debug` in debug environment and build with `appIcon` in release environment.

`IconOverlaying` is modified your `ipa` file after archive, it will modified the png file in `.ipa`, but app  in iOS11 won't use png file in `.ipa` anymore, the app in iOS11 will use `appIcon` in assets.

## Adding LLDebugTool to your project

#### First step

Add a `New Run Script Phase` in your project.


## Note

## Communication

- If you **need help**, open an issue.
- If you'd like to **ask a general question**, open an issue.
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **find anything wrong or anything dislike**, open an issue.
- If you **have some good ideas or some requests**, send mail(llworkinggroup1992@gmail.com) to me.
- If you **want to contribute**, submit a pull request.

## Contact

- Send email to [llworkinggroup1992@gmail.com](llworkinggroup1992@gmail.com)
- Send message in twitter [@HdbLi](https://twitter.com/HdbLi)
- Send message in [JianShu](https://www.jianshu.com/u/a3c82fae85be)

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
