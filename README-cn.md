# LLIconVersioning

一个可以创建app版本信息icon的脚本

[![Platform](https://img.shields.io/badge/Platform-Xcode-blue.svg)](https://img.shields.io/badge/Platform-Xcode-blue.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-shell-yellow.svg)](https://img.shields.io/badge/Language-shell-yellow.svg)
[![Twitter](https://img.shields.io/badge/twitter-@HdbLi-1DA1F2.svg)](https://twitter.com/HdbLi)

## 简介

[Click here for an English introduction](https://github.com/HDB-Li/LLIconVersioning)

LLIconVersioning是一个脚本，可以自动创建带有调试信息的appIcon。在run script中的集成脚本，可以在每次build或archive时自动创建带有版本信息的图标，还可以自动管理构建号。

## 预览

[![Rendering](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Rendering.png)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Rendering.png)

`1.0.0` is app version, `9` is build number, `Debug` is environment name.

## 我能用 LLIconVersioning 做什么?

这是一个可以帮助你管理图标的脚本，你可以更容易地看到应用程序版本信息。

并且它也可以自动管理build number，例如`1`增长成`2`，或者`1.0.0`增长成`1.0.1`，或者使用日期来设置你的build number，例如`201808311200`。

## 添加 LLIconVersioning 到你的项目中

1. 在你的Mac上安装 ghostscript 和 ImageMagick，你可以通过brew来快速的安装：`brew install imagemagick` 和 `brew install ghostscript`。

2. 在你的项目中新增一个 `New Run Script Phase`，并且填写`LLIconVersion.sh`的路径。如果你将 `LLIconVersion.sh` 放到根目录下，你可以填写`$SRCROOT/LLIconVersion.sh`，如果你将 `LLIconVersion.sh` 放到某个文件夹下，你需要填写`$SRCROOT/your folder name/LLIconVersion.sh`。

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Add-Run-Script.jpg" width="50%"></img>
</div>

3. 复制 `LLIconVersion.sh`到指定目录。

4. 在你想要archive或者安装app给测试前，运行 `Build`(快捷键 : `command + B` )。原因请查看[Q&A](https://github.com/HDB-Li/LLIconVersioning/blob/master/README.md#q3--why-need-call-build-before-using)。

5. 运行你的项目看看效果。

6. 如果你对颜色或者字体不满意，可以在脚本中修改这些配置参数。

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Custom-Parameter.jpg" width="50%"></img>
</div>

## Q&A

### Q1 :  `LLIconVersioning` 和 `IconOverlaying` 有什么区别?

`LLIconVersioning` 是根据 [`IconOverlaying`](https://github.com/krzysztofzablocki/IconOverlaying)修改的, 但是 `IconOverlaying` 已经不再支持 Xcode 9 and iOS 11。

虽然 `LLIconVersioning` 是根据 `IconOverlaying`修改的，但是中心思想是不一样的。

`LLIconVersioning` 是修改你的`project.pbxproj`，然后将Debug环境的`ASSETCATALOG_COMPILER_APPICON_NAME`的值从`appIcon`设置成`appIcon-Debug`，这意味着你的app会使用 `appIcon-Debug`来创建debug环境的图标，使用`appIcon`创建release环境的图标。

`IconOverlaying`是在archive后修改你的`ipa`，他会修改`.ipa`中的png文件，但是ios11的app已经不在使用`ipa`中的png文件，而是直接使用assets中的`appIcon`来创建图标。

### Q2 :  `LLIconVersioning` 在build时都做了什么?

1. 检查本地数据，判断是否需要更新图标。
2. 检查是否在Mac上安装了必要的库。
3. 复制`appIcon` 到 `appIcon-Debug`，将app版本信息写到图片上。
4. 修改Debug环境里的 `ASSETCATALOG_COMPILER_APPICON_NAME`值为`appIcon-Debug`。
5. 自动修改build number。

### Q3 : 为什么需要在使用前调用`build`?

`LLIconVersioning` 是动态的修改 `project.pbxproj` 和 `assets`，因为run script只能在`ipa`生成后调用，所以脚本无法修改当前的`ipa`中的`assets`资源，`build`相当于运行脚本去创建下一次`ipa`的数据，所以你在archive或者给测试安装app前，需要先build一下。

### Q4 : 为什么会收到这样的错误?

当你手动删除`assets`中的`appIcon-Debug`时，你会收到一个这样的错误`None of the input catalogs contained a matching stickers icon set or app icon set named  "AppIcon-Debug"`。

[![Run Error](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Run-Error-1.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Run-Error-1.jpg)

在 `Build settings` 中搜 `asset catalog`，双击并且修改值为`appIcon`，再运行一次。

[![Fix Error](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Fix-Error-1.jpg)](https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLIconVersioning/Fix-Error-1.jpg)

### Q5 : 为什么不好使?

检查你是否安装了ghostscript/ImageMagick，或者查看xcode中的调试信息，如果你还无法解决问题，打开一个 issue。

### Q6 : 我可以修改哪些参数?

所有可调整的参数都写在了脚本文件的第一和第二部分，你可以阅读注释来进行修改。

## 联系

- **如果你需要帮助**，打开一个issue。
- **如果你想问一个普遍的问题**，打开一个issue。
- **如果你发现了一个bug**，_并能提供可靠的复制步骤_，打开一个issue。
- **如果你有一个功能请求**，打开一个issue。
- **如果你发现有什么不对或不喜欢的地方**，就打开一个issue。
- **如果你有一些好主意或者一些需求**，请发邮件(llworkinggroup@qq.com)给我。
- **如果你想贡献**，提交一个pull request。

## 联系

- 可以发邮件到[llworkinggroup1992@gmail.com](llworkinggroup1992@gmail.com)
- 可以在twitter中[@HdbLi](https://twitter.com/HdbLi)发私信给我。
- 可以在[简书](https://www.jianshu.com/u/a3c82fae85be)中发私信给我。

## 许可

这段代码是根据 [MIT license](LICENSE) 的条款和条件发布的。
