# How To Contribute

Thank you for your interest in contributing to Hyperion. When contributing to Hyperion you will first want to make an [issue](https://github.com/willowtreeapps/Hyperion-iOS/issues/new) so that we can discuss the change. Please follow our [code of conduct](CODE_OF_CONDUCT.md) when interacting with this project.  If you find an existing issue that you want to fix, then claim it by assigning it to yourself. Once an issue has been discussed/approved:

1. Fork Hyperion.
2. Clone your fork of Hyperion.
3. Make changes and commit them.
4. Push these changes up to your fork.
5. Submit a pull request from your fork with the "base" being `willowtreeapps:develop` and then the "compare" being your branch.

Please follow [this guide](https://help.github.com/articles/fork-a-repo/) for more instruction on forking.

### Hyperion Core

It is crucial that any change made to HyperionCore does not break backwards compatibility with older plugins. This is why it is important to communicate any changes to HyperionCore with the owners via [issue](https://github.com/willowtreeapps/Hyperion-iOS/issues/new).

### Hyperion Plugins

Most Hyperion plugins should go in their own repo. If you feel that there is a plugin that would be of use to the entire user base, please submit an issue and we will discuss whether it should go into the main repo. If your plugin is not a fit for the main repo, then you can still link to it in our [ReadMe.md](https://github.com/willowtreeapps/Hyperion-iOS/blob/master/README.md#third-party-plugins) under the Third-Party Plugins section. Just submit a pull request with the change to the ReadMe and make the base `master`.

---

By submitting a pull request, you represent that you have the right to license
your contribution to WillowTree and the community, and agree by submitting the patch
that your contributions are licensed under the [MIT License](LICENSE).
