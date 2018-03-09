rm -rf output
mkdir output

carthage build --no-skip-current --verbose
carthage archive --output output/Hyperion.framework.zip
