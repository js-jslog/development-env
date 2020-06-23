# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to ~~[Semantic Versioning](https://semver.org/spec/v2.0.0.html).~~
[Compatible Versioning](https://gitlab.com/staltz/comver).

### Format
- Added: for new features.
- Changed: for changes in existing functionality.
- Deprecated: for once-stable features removed in upcoming releases.
- Removed: for deprecated features removed in this release.
- Fixed: for any bug fixes.
- Security: to invite users to upgrade in case of vulnerabilities.


## [Unreleased](https://github.com/js-jslog/development-env/compare/v8.0.0...HEAD) - yyyy-mm-dd
### Added
- MINOR: Install neovim docs

### Changed
- MINOR: Rearrange inital apk installs to separate basic 'normal' stuff from 'developer' stuff

## [v8.1.0](https://github.com/js-jslog/development-env/releases/tag/v8.1.0) - 2020-06-19
### Added
- MINOR: Add expo cli globally to npm
- MINOR: Add jsx formatting manager as vim plugin in vim config

## [v8.0.0](https://github.com/js-jslog/development-env/releases/tag/v8.0.0) - 2020-06-19
### Added
- MINOR: Python msgpack
- MINOR: Linux ripgrep package

### Changed
- MINOR: CoC and Denite vim config split out from main vim config file
- MAJOR: dotfiles dependency updated with plugin alterations

## [v7.0.0](https://github.com/js-jslog/development-env/releases/tag/v7.0.0) - 2020-06-18
### Changed
- MAJOR: Change base image from ubuntu:focal to alpine:3.12.0 - significant resultant changes to fundamentals like user account setup
- MAJOR: Change ownership of tdd yeoman generator to root which will impact ability to edit and test inside container

### Removed
- MAJOR: `sudo` permissions have been removed from the developer user
- MAJOR: `vim` no longer mapped to nvim (has no function)
- MAJOR: A lot of bash functionality, some of which will be gradually reintroduced as required (reason being, bash was installed anew)
- MAJOR: Ability to manage host docker instance from container
- MAJOR: Several rarely used utilities like postgresql client which can be reinstated if required
- MAJOR: Several rarely used utilities which are background features of Ubuntu which I'm unaware are missing at the moment
- MAJOR: Several rarely used and (I think flawed) on my personal Yeoman generators

## [v6.0.0](https://github.com/js-jslog/development-env/releases/tag/v6.0.0) - 2020-06-16
### Changed
- MAJOR: Updated dotfiles submodule with shift from Deopolete and Nvim-Typescript to CoC with extensions. Performance and feature improvement.

### Removed
- MAJOR: Various nvim plugins which are not essential and need to be reviewed.
- MAJOR: Various environment dependencies which were only required for the replaced deoplete and associates.

## [v5.0.0](https://github.com/js-jslog/development-env/releases/tag/v5.0.0) - 2020-06-13
### Changed
- MAJOR: Upgrade base image from Ubuntu 16 to 20
- MAJOR: Replace vim with neovim
- MINOR: Add v to start of git tag names

### Added
- MAJOR: Additional dependencies as required for desired neovim enhancements

### Removed
- MAJOR: Vim and it's dependencies not shared with neovim


## Github release list
- [unreleased](https://github.com/js-jslog/development-env/compare/v8.1.0...HEAD)
- [v8.1.0](https://github.com/js-jslog/development-env/releases/tag/v8.1.0)
- [v8.0.0](https://github.com/js-jslog/development-env/releases/tag/v8.0.0)
- [v7.0.0](https://github.com/js-jslog/development-env/releases/tag/v7.0.0)
- [v6.0.0](https://github.com/js-jslog/development-env/releases/tag/v6.0.0)
- [v5.0.0](https://github.com/js-jslog/development-env/releases/tag/v5.0.0)
- [v4.3.0](https://github.com/js-jslog/development-env/releases/tag/4.3.0)
