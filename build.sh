rm -rf output
mkdir output

carthage build --archive --verbose
(cd Carthage/Build && zip -r ../../output/HyperionCore.framework.Plugins.zip .)
