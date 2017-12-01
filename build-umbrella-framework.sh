
rm -rf tmpsim
rm -rf tmpos
mkdir output/iphoneos
mkdir output/simulator

SCHEME=$1

xcodebuild \
-workspace "HyperionFramework.xcworkspace" \
-scheme $SCHEME \
-configuration "$Debug" \
only_active_arch=no \
defines_module=yes \
-sdk "iphoneos" \
-derivedDataPath "tmpos" \
OTHER_CFLAGS="-fembed-bitcode" \
ENABLE_BITCODE=YES \
clean build

find tmpos -iname "${SCHEME}.framework" -exec mv {} output/iphoneos/ \;

xcodebuild \
-workspace "HyperionFramework.xcworkspace" \
-scheme $SCHEME \
-configuration "$Debug" \
only_active_arch=no \
defines_module=yes \
-sdk "iphonesimulator" \
-derivedDataPath "tmpsim" \
OTHER_CFLAGS="-fembed-bitcode" \
ENABLE_BITCODE=YES \
clean build

find tmpsim -iname "${SCHEME}.framework" -exec mv {} output/simulator/ \;

cp -a output/iphoneos/${SCHEME}.framework output/${SCHEME}.framework
cp -a output/iphoneos/${SCHEME}.framework/${SCHEME} output/${SCHEME}iOS
cp -a output/simulator/${SCHEME}.framework/${SCHEME} output/${SCHEME}Simulator

rm output/${SCHEME}.framework/${SCHEME}
lipo -create output/${SCHEME}Simulator output/${SCHEME}iOS -output output/${SCHEME}.framework/${SCHEME}
#
rm output/${SCHEME}iOS
rm output/${SCHEME}Simulator

rm -rf output/iphoneos
rm -rf output/simulator

rm -rf tmpsim
rm -rf tmpos
