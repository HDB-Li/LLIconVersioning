# LLIconVersioning

A script that automatically creates an appIcon with debugging information

[![Platform](https://img.shields.io/badge/Platform-Xcode-blue.svg)](https://img.shields.io/badge/Platform-Xcode-blue.svg)
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

## Adding LLDebugTool to your project

1. Installed ghostscript and ImageMagick on your mac, you can use brew to simplify process: `brew install imagemagick` and `brew install ghostscript`.

2. Add a `New Run Script Phase` in your project and write the `LLIconVersion.sh`'s path. If you put `LLIconVersion.sh` in root path, you can write `$SRCROOT/LLIconVersion.sh` in run script. If you put `LLIconVersion.sh` in a folder in root path , you need write `$SRCROOT/your folder name/LLIconVersion.sh` in run script.

[![Add run script](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Add-Run-Script.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Add-Run-Script.jpg)

3. Copy `LLIconVersion.sh` to your target path.

4. Call `Build`(shortcuts : `command + B` ) before you want to archive or install the app to the tester. See [Q&A](https://github.com/HDB-Li/LLIconVersioning/blob/master/README.md#q3--why-need-call-build-before-using) for reason.

5. Run your project and see what happend.

6. If the color or the font size or whatever is not what you want, modify the parameter configuration in script.

[![Custom Parameter](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Custom-Parameter.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Custom-Parameter.jpg)

## Q&A

### Q1 : What's the difference between `LLIconVersioning` and `IconOverlaying`?

`LLIconVersioning` is modified according to [`IconOverlaying`](https://github.com/krzysztofzablocki/IconOverlaying), but `IconOverlaying` is no longer support Xcode 9 and iOS 11. 

Although `LLIconVersioning` is modified according to `IconOverlaying`, but the central idea is different. 

`LLIconVersioning` is modified your `project.pbxproj`, and set your `ASSETCATALOG_COMPILER_APPICON_NAME` from `appIcon` to `appIcon-Debug` in debug environment, it means your app will build with `appIcon-Debug` in debug environment and build with `appIcon` in release environment.

`IconOverlaying` is modified your `ipa` file after archive, it will modified the png file in `.ipa`, but app  in iOS11 won't use png file in `.ipa` anymore, the app in iOS11 will use `appIcon` in assets.

### Q2 : What did `LLIconVersioning` do while build?

1. Check local data to see if the icon needs to be updated.
2. Check that the necessary libraries are installed on the Mac.
3. Copy `appIcon` to `appIcon-Debug` and write the app version information on the picture.
4. Modify the `ASSETCATALOG_COMPILER_APPICON_NAME`'s value to `appIcon-Debug` in debug environment.
5. Modify build number automatically.

### Q3 : Why need call `build` before using?

`LLIconVersioning` is dynamic modification of `project.pbxproj` and `assets`. Because run script is called after `ipa` production, run script cannot modify the `assets` resource in `ipa`, `build` is equivalent to this run script to create data for the next `ipa`, so you should build it first when you need.

### Q4 : Why do I receive such an error?

When you manually delete `appIcon-Debug` in `assets`, you receive an error like `None of the input catalogs contained a matching stickers icon set or app icon set named  "AppIcon-Debug"`.

[![Run Error](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Run-Error-1.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Run-Error-1.jpg)

Search `asset catalog` in `Build settings`, double click and change the value to `appIcon`. Run again.

[![Fix Error](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Fix-Error-1.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Fix-Error-1.jpg)

### Q5 : Why doesn't it work?

Check to see if ghostscript/ImageMagick is installed or see debug info in xcode. If you can't solve your problem, open an issue.

### Q6 : Is there any configuration I can change?

All adjustable parameter configurations are in part 1 and part 2 of the script, and you can read the comments to make changes.

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
