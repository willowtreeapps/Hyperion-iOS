rm -rf output
mkdir output

carthage build --use-xcframeworks --archive --verbose
(cd Carthage/Build && zip -r ../../output/HyperionCore.framework.Plugins.zip .)
