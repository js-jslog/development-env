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


## [Unreleased](https://github.com/js-jslog/development-env/compare/v12.1.0...HEAD) - yyyy-mm-dd

## [v12.1.0](https://github.com/js-jslog/development-env/releases/tag/v12.1.0) - 2024-03-07
### Fixed
- MINOR: Fixed the incorrect docker tag in the runcontainer.ps1 script

### Changed
- MAJOR: Changed the project folder structure, impacting the commands which need to be run at setup

### Added
- MINOR: Clipboard management between host and container

## [v12.0.0](https://github.com/js-jslog/development-env/releases/tag/v12.0.0) - 2024-03-07
### Changed
- MAJOR: Made the README.md solely responsible for the documentation of utility. No more run commands included in the Docker image labels.
- MINOR: A small change to the tokyonight config of the neovim-config submodule pulled in
- MINOR: Windows line endings changed to unix. The change to Windows must have happened during v11.0.0 without me noticing or recording.

### Added
- MINOR: Added git config setup scripts, and updated README.md instructions to direct to their use (user can still choose manual method if these files are not appropriate for them)
- MINOR: Add a dev container starter script for powershell


## [v11.0.0](https://github.com/js-jslog/development-env/releases/tag/v11.0.0) - 2024-03-06
### Added
- MINOR: Git credentials manager

### Changed
- MAJOR: Update Neovim to 0.10
- MAJOR: Pivot to presumption of dev container based approach
- MINOR: Pivot to presumption of container persistence per project

### Removed
- MAJOR: Remove much of the functionality. Review https://github.com/js-jslog/development-env/pull/16/files for details.

## [v10.0.0](https://github.com/js-jslog/development-env/releases/tag/v10.0.0) - 2020-04-05
### Changed
- MAJOR: Update Neovim to 0.5 with replacements for most used functionality with potential techdebt regressions to be addressed with live testing

## [v9.0.0](https://github.com/js-jslog/development-env/releases/tag/v9.0.0) - 2020-06-28
### Added
- MINOR: Aliased vim for nvim

### Changed
- MAJOR: Updated .gitconfig to use nvim rather than vim
- MINOR: Moved some bash aliases from .bashrc to .bash_aliases file in dotfiles submodule

## [v8.2.0](https://github.com/js-jslog/development-env/releases/tag/v8.2.0) - 2020-06-25
### Added
- MINOR: Install neovim docs
- MINOR: Add .bashrc with enough functionality to colour prompt and load .bash_aliases

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
- [unreleased](https://github.com/js-jslog/development-env/compare/v12.1.0...HEAD)
- [v12.1.0](https://github.com/js-jslog/development-env/releases/tag/v12.1.0)
- [v12.0.0](https://github.com/js-jslog/development-env/releases/tag/v12.0.0)
- [v11.0.0](https://github.com/js-jslog/development-env/releases/tag/v11.0.0)
- [v10.0.0](https://github.com/js-jslog/development-env/releases/tag/v10.0.0)
- [v10.0.0](https://github.com/js-jslog/development-env/releases/tag/v10.0.0)
- [v9.0.0](https://github.com/js-jslog/development-env/releases/tag/v9.0.0)
- [v8.2.0](https://github.com/js-jslog/development-env/releases/tag/v8.2.0)
- [v8.1.0](https://github.com/js-jslog/development-env/releases/tag/v8.1.0)
- [v8.0.0](https://github.com/js-jslog/development-env/releases/tag/v8.0.0)
- [v7.0.0](https://github.com/js-jslog/development-env/releases/tag/v7.0.0)
- [v6.0.0](https://github.com/js-jslog/development-env/releases/tag/v6.0.0)
- [v5.0.0](https://github.com/js-jslog/development-env/releases/tag/v5.0.0)
- [v4.3.0](https://github.com/js-jslog/development-env/releases/tag/4.3.0)
