# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v3.1.0](https://github.com/purescript-web/purescript-web-promise/releases/tag/v3.0.0) - 2022-07-30

New features:
- Added `thenOrCatch` (#16 by @garyb)

## [v3.0.0](https://github.com/purescript-web/purescript-web-promise/releases/tag/v3.0.0) - 2022-04-27

Breaking changes:
- Migrate FFI to ES modules (#14 by @JordanMartinez)

New features:

Bugfixes:

Other improvements:

## [v2.1.0](https://github.com/purescript-web/purescript-web-promise/releases/tag/v2.1.0) - 2021-06-23

New features:
- Added `toPromise` and `fromPromise` helper functions to the `LazyPromise` module for convenient transformations between the `Promise` and `LazyPromise` types (#12 by @thomashoneyman)

## [v2.0.0](https://github.com/purescript-web/purescript-web-promise/releases/tag/v2.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#6, #7)

New features:
- Add roles declarations to allow safe coercions (#4)

Bugfixes:
- Properly account for Promise flattening and add lazy boxing (#8)

Other improvements:
- Migrated CI to GitHub Actions and updated installation instructions to use Spago (#5)
- Added a CHANGELOG.md file and pull request template (#9, #10)

## [v1.0.3](https://github.com/purescript-web/purescript-web-promise/releases/tag/v1.0.3) - 2020-03-30

- Fixed eta-reduced FFI functions (@thomashoneyman)

## [v1.0.2](https://github.com/purescript-web/purescript-web-promise/releases/tag/v1.0.2) - 2020-01-14

- Fixed typo in FFI

## [v1.0.1](https://github.com/purescript-web/purescript-web-promise/releases/tag/v1.0.1) - 2020-01-14

- Fixed typo in FFI

## [v1.0.0](https://github.com/purescript-web/purescript-web-promise/releases/tag/v1.0.0) - 2020-01-14

- Initial release
