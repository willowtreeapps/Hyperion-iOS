#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

bundle exec jazzy \
--objc \
--clean \
--author WillowTree \
--author_url https://willowtreeapps.com \
--github_url https://github.com/willowtreeapps/Hyperion-iOS \
--output Docs \
--umbrella-header Core/HyperionCore.h \
--framework-root . \
--sdk iphonesimulator