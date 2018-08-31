#!/bin/sh
#
# More informations please see https://github.com/HDB-Li/LLIconVersioning
#
# V1.0.0
#
# 2018.08.30
#
#
#
######################################################
# 1. 脚本集成到Xcode工程的Target
######################################################
#
# --- Copy the SCRIPT to the Run Script of Build Phases in the Xcode project ---
#
# # Assets中的appIcon文件名
# # AppIcon file name in Assets
APPICON_NAME="AppIcon"
#
# # Target的序号，第一个target就写0，第二个就写1。
# # Index of the target, the first target is going to be 0, the second one is going to be 1.
TARGET_INDEX=0
#
# # 编译环境名称
# # Build configuration name
TARGET_CONFIGURATION_NAME="Debug"
#
# # 是否自动增加build number, "F" 不自增， "T" 自增
# # Whether to increase build number automatically, "F" means false, "T" means true.
AUTO_INCREASE_BUILD_NUMBER="T"
#
# # 只在Release环境下，自增build number, 只有在AUTO_INCREASE_BUILD_NUMBER="T"时有效。"F" 所有环境都会自增build number，"T" 只在Release环境下自增build number。
# # In the Release environment only, increase build number automatically, only valid if AUTO_INCREASE_BUILD_NUMBER="T". "F" means all environments will increase build number automatically. "T" means increase build number automatically in Release environment only.
# AUTO_INCREASE_BUILD_NUMBER_ONLY_IN_RELEASE="T"
#
# # 使用日期当build number，只有在AUTO_INCREASE_BUILD_NUMBER="T"时有效。
# # Use the date as the build number, only valid if AUTO_INCREASE_BUILD_NUMBER="T".
# USE_DATE_AS_BUILD_NUMBER="T"
#
#
#
# --- 创建ICON的配置信息，除了颜色参数，大多数情况下你不需要修改这些参数。  ---
# ---  The configuration information for creating an ICON, except for color parameters, in most cases you do not need to modify these parameters. ---
#
# # 右上角Badge参数
# # Top right badge label parameters
ICON_BADGE_BACKGROUND_COLOR="rgba(255,222,111,1.0)"
ICON_BADGE_TEXT_COLOR="rgba(255,255,255,1.0)"
ICON_BADGE_FONT_SIZE=15
ICON_BADGE_HEIGHT=20
#
# # 底部app信息参数
# # Bottom app information parameters
ICON_INFO_TEXT_COLOR="rgba(255,255,255,1.0)"
ICON_INFO_FONT_SIZE=13
ICON_INFO_HEIGHT=35
#
# #
# source LLIconVersioning.sh
#
#
#
#######################################################
# 2. 获取和拼接参数
#######################################################
#
# --- Get and splicing parameters ---
#
# # Assets中Debug环境的appIcon文件名
# # AppIcon file name of the Debug environment in Assets
DEBUG_APPICON_NAME="${APPICON_NAME}-Debug"
#
# # 获取app版本号
# # Get app version
APP_VERSION=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "${INFOPLIST_FILE}")
#
# # 获取build号
# # Get build number
APP_BUILD_NUM=$(/usr/libexec/PlistBuddy -c 'Print CFBundleVersion' "${INFOPLIST_FILE}")
#
# # Icon上显示的文字内容, 你可以在这里修改标题格式
# # The caption displayed on the Icon, you can change the caption format here
CAPTION="$APP_VERSION\n($APP_BUILD_NUM)"
#
# # Badge文字
# # Badge caption
BADGE_CAPTION="$CONFIGURATION"
#
#
echo "APP_VERSION=$APP_VERSION"
echo "APP_BUILD_NUM=$APP_BUILD_NUM"
echo "CAPTION=$CAPTION"
str="$APP_BUILD_NUM"
echo ${str##*.}
#
#######################################################
# 3. 定义方法
#######################################################
#
# --- Define methods ---
#
# # 打印错误信息
# # Print error message
function exitWithMessage(){
    echo "--------------------------------"
    echo "${1}"
    echo "--------------------------------"
    exit ${2}
}
#
# # 处理icon
# # Processing icon
function processIcon() {

    base_file=$1
    echo "Start process icon,base_file=$base_file"

    BASE_FLODER_PATH=`dirname $base_file`

    cd "$BASE_FLODER_PATH"

    width=`identify -format %w ${base_file}`
    height=`identify -format %h ${base_file}`
    band_height=$((($height * $ICON_INFO_HEIGHT) / 100))
    band_position=$(($height - $band_height))
    text_position=$(($band_position - 3))
    point_size=$((($ICON_INFO_FONT_SIZE * $width) / 100))
    badge_width=$((($width * 200) / 100))
    badge_height=$((($height * $ICON_BADGE_HEIGHT) / 100))
    badge_point_size=$((($ICON_BADGE_FONT_SIZE * $width) / 100))

    echo "Image dimensions ($width x $height) - band height $band_height @ $band_position - point size $point_size"

    target_file=`basename $base_file`
    echo "target_file=$target_file"

    convert ${base_file} -blur 10x8 blurred.png
    convert blurred.png -gamma 0 -fill white -draw "rectangle 0,$band_position,$width,$height" mask.png
    convert -size ${width}x${band_height} xc:none -fill 'rgba(0,0,0,0.2)' -draw "rectangle 0,0,$width,$band_height" labels-base.png
    convert -background none -size ${width}x${band_height} -pointsize $point_size -fill $ICON_INFO_TEXT_COLOR -gravity center -gravity South caption:"$CAPTION" labels.png
    convert ${base_file} blurred.png mask.png -composite temp.png
    convert temp.png labels-base.png -geometry +0+$band_position -composite labels.png -geometry +0+$text_position -geometry +${w}-${h} -composite "${base_file}"
    convert -background $ICON_BADGE_BACKGROUND_COLOR -size ${badge_width}x${badge_height} -pointsize $badge_point_size -fill $ICON_BADGE_TEXT_COLOR -gravity center caption:$BADGE_CAPTION badge.png
    convert badge.png -background none -rotate 45 badge.png
    convert ${base_file} badge.png -gravity SouthWest -composite ${base_file}

    if [ $? != 0 ];then
        echo "convert failed."
    fi

    rm blurred.png
    rm labels-base.png
    rm labels.png
    rm mask.png
    rm temp.png
    rm badge.png

    echo "Finish process"
}
#
#
#
#######################################################
# 4. 检查是否安装必要的工具
#######################################################
#
# --- Check that the necessary tools are installed ---
#
#
# # 检查是否安装了ghostscript/ImageMagick
# # Check to see if ghostscript/ImageMagick is installed
echo "Checking installed ghostscript/ImageMagick"

convertPath=`which convert`
gsPath=`which gs`

if [[ ! -f ${convertPath} || -z ${convertPath} ]]; then
    convertValidation=true;
else
    convertValidation=false;
fi

if [[ ! -f ${gsPath} || -z ${gsPath} ]]; then
    gsValidation=true;
else
    gsValidation=false;
fi

if [[ "$convertValidation" = true || "$gsValidation" = true ]]; then
    echo "WARNING: Skipping Icon versioning, you need to install ImageMagick and ghostscript (fonts) first, you can use brew to simplify process:"

    if [[ "$convertValidation" = true ]]; then
        exitWithMessage "brew install imagemagick" 0
    fi
    if [[ "$gsValidation" = true ]]; then
        exitWithMessage "brew install ghostscript" 0
    fi
exit 0;
fi
#
#
#
#######################################################
# 5. 判断是否需要创建新的AppIcon图片
#######################################################
#
# --- Determine if a new AppIcon images needs to be created ---
#
#
NEED_CREATE_NEW_ICONS="T"
USER_DATA_BAT="ll_user.bat"
USER_DATA_BAT_PATH=`find $SRCROOT -name "${USER_DATA_BAT}"`
if [ "$USER_DATA_BAT_PATH" = "" ]; then
    echo "No user data"
else
    echo "Find user data"
    USER_DATA=`cat ${USER_DATA_BAT_PATH}`
    if [ "$USER_DATA" = "$CAPTION" ]; then
        NEED_CREATE_NEW_ICONS="F"
    fi
fi
echo "NEED_CREATE_NEW_ICONS=$NEED_CREATE_NEW_ICONS"
#
#
#
#######################################################
# 5. 复制AppIcon到AppIcon-Debug
#######################################################
#
# --- Copy AppIcon to AppIcon-Debug ---
#
#
if [ "$NEED_CREATE_NEW_ICONS" = "T" ];then
    echo "Begin copy icon files"

    APPICON_SET_PATH=`find $SRCROOT -name "${APPICON_NAME}.appiconset"`
    echo "APPICON_SET_PATH=$APPICON_SET_PATH"
    if [ "$APPICON_SET_PATH" = "" ]; then
        exitWithMessage "WARNING :Get APPICON_SET_PATH failed." 0
    fi

    # TODO: Can't get real count.
    APPICON_SET_PATH_COUNT=`echo ${#APPICON_SET_PATH[@]}`
    echo "APPICON_SET_PATH_COUNT=$APPICON_SET_PATH_COUNT"

    if [ "$APPICON_SET_PATH_COUNT" != "1" ];then
        exitWithMessage "WARNING :Get ${APPICON_NAME}.appiconset failed." 0
    fi

    ASSET_PATH=`echo $(dirname ${APPICON_SET_PATH})`
    echo "ASSET_PATH=$ASSET_PATH"
    if [ "$ASSET_PATH" = "" ]; then
        exitWithMessage "WARNING :Get ASSET_PATH failed." 0
    fi

    DEBUG_APPICON_SET_PATH="${ASSET_PATH}/${DEBUG_APPICON_NAME}.appiconset"
    echo "DEBUG_APPICON_SET_PATH=$DEBUG_APPICON_SET_PATH"
    if [ "$DEBUG_APPICON_SET_PATH" = "" ]; then
        exitWithMessage "WARNING :Get DEBUG_APPICON_SET_PATH failed." 0
    fi

    rm -rf $DEBUG_APPICON_SET_PATH
    if [ $? != 0 ];then
        exitWithMessage "WARNING :Remove ${DEBUG_APPICON_SET_PATH} failed." 0
    fi

    cp -rf $APPICON_SET_PATH $DEBUG_APPICON_SET_PATH
    if [ $? != 0 ];then
        exitWithMessage "WARNING :Copy ${APPICON_NAME} to ${DEBUG_APPICON_NAME} failed." 0
    fi

    echo "Finish copy icon files."
    USER_DATA_BAT_PATH="${DEBUG_APPICON_SET_PATH}/${USER_DATA_BAT}"
    echo "${CAPTION}" > "${USER_DATA_BAT_PATH}"
fi
#
#
#
#######################################################
# 6. 处理AppIcon-Debug
#######################################################
#
# --- Process AppIcon-Debug ---
#
#
if [ "$NEED_CREATE_NEW_ICONS" = "T" ];then
    find "$DEBUG_APPICON_SET_PATH" -type f -name "*.png" -print0 |

    while IFS= read -r -d '' file; do

    processIcon "${file}"

    done

    echo "Finish all process"
fi
#
#
#
#######################################################
# 7. 修改project.pbxproj
#######################################################
#
# --- Modify project.pbxproj ---
#
#
echo "PROJECT_FILE_PATH is $PROJECT_FILE_PATH"

# Get rootObject in project.
ROOT_OBJECT=`/usr/libexec/PlistBuddy -c "print :rootObject" $PROJECT_FILE_PATH/project.pbxproj`
echo "ROOT_OBJECT is $ROOT_OBJECT"

# Get PBXNativeTarget in project.
PBXNATIVE_TARGET=`/usr/libexec/PlistBuddy -c "print :objects:$ROOT_OBJECT:targets:$TARGET_INDEX" $PROJECT_FILE_PATH/project.pbxproj`
echo "TARGET is $PBXNATIVE_TARGET"

# Get BuildConfigurationList in project.
BUILD_CONFIGURATION_LIST=`/usr/libexec/PlistBuddy -c "print :objects:$PBXNATIVE_TARGET:buildConfigurationList" $PROJECT_FILE_PATH/project.pbxproj`
echo "BUILD_CONFIGURATION_LIST is $BUILD_CONFIGURATION_LIST"

# Get BuildConfiguations for target.
BUILD_CONFIGURATIONS==`/usr/libexec/PlistBuddy -c "print :objects:$BUILD_CONFIGURATION_LIST:buildConfigurations" $PROJECT_FILE_PATH/project.pbxproj`
echo "BUILD_CONFIGURATIONS is $BUILD_CONFIGURATIONS"

# Find target configuration.
for i in ${BUILD_CONFIGURATIONS}
do
    ITEM=`/usr/libexec/PlistBuddy -c "print :objects:$i" $PROJECT_FILE_PATH/project.pbxproj`
    if [ "$ITEM" != "" ]
    then
        # Get configuration name.
        NAME=`/usr/libexec/PlistBuddy -c "print :objects:$i:name" $PROJECT_FILE_PATH/project.pbxproj`
        if [ "$NAME" = "$TARGET_CONFIGURATION_NAME" ]
        then
        # Get original appIcon name.
            ASSETCATALOG_COMPILER_APPICON_NAME=`/usr/libexec/PlistBuddy -c "print :objects:$i:buildSettings:ASSETCATALOG_COMPILER_APPICON_NAME" $PROJECT_FILE_PATH/project.pbxproj`
            echo "ASSETCATALOG_COMPILER_APPICON_NAME=$ASSETCATALOG_COMPILER_APPICON_NAME"
            if [ "$ASSETCATALOG_COMPILER_APPICON_NAME" != "$DEBUG_APPICON_NAME" ]
            then
            # Set new appIcon name.
            /usr/libexec/PlistBuddy -c "Set :objects:$i:buildSettings:ASSETCATALOG_COMPILER_APPICON_NAME ${DEBUG_APPICON_NAME}" $PROJECT_FILE_PATH/project.pbxproj
                if [ $? != 0 ];then
                exitWithMessage "WARNING :Set new appicon name failed." 0
                fi
            fi
        fi
    fi
done
#
#
#
#######################################################
# 8. 修改build number
#######################################################
#
# --- Modify build number ---
#
#
if [ "$AUTO_INCREASE_BUILD_NUMBER" = "T" ]; then
    if [ "$AUTO_INCREASE_BUILD_NUMBER_ONLY_IN_RELEASE" = "T" ]; then
        if [ $CONFIGURATION != Release ]; then
            exitWithMessage "CONFIGURATION=$CONFIGURATION, don't need increase build number." 0
        fi
    fi

    if [ "$USE_DATE_AS_BUILD_NUMBER" = "T" ]; then
        NEW_BUILD_NUM=`date +%Y%m%d%H%M`
    else
        NEW_BUILD_NUM=$(expr $APP_BUILD_NUM + 1)
        if [ $? != 0 ];then
            str="$APP_BUILD_NUM"
            LAST_NUMBER=`echo ${str##*.}`
            FIRST_NUMBER=`echo ${str%.*}`
            NEW_LAST_NUMBER=$(expr $LAST_NUMBER + 1)
            if [ $? != 0 ];then
                exitWithMessage "Calculate build number failed." 0
            fi
            NEW_BUILD_NUM="${FIRST_NUMBER}.${NEW_LAST_NUMBER}"
        fi
    fi

    echo "NEW_BUILD_NUM=$NEW_BUILD_NUM"
    if [ NEW_BUILD_NUM = "" ];then
        exitWithMessage "Calculate build number failed." 0
    fi
    $(/usr/libexec/PlistBuddy -c "Set CFBundleVersion ${NEW_BUILD_NUM}" "${INFOPLIST_FILE}")
    if [ $? != 0 ];then
        exitWithMessage "Set build number failed." 0
    fi
    echo "Set build number success"
fi
# --- End ---
#
########################################################

