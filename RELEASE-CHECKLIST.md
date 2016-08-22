# Release checklist

How to release a new version of LayoutKit.

- [ ] Bump version in LayoutKit.podspec.

    `spec.version          = '2.0.0'`
- [ ] Bump the version in `Info.plist`

    ```
<key>CFBundleShortVersionString</key>
<string>2.0.0</string>
    ```
- [ ] Verify that the podspec is valid.

    ```
$ pod lib lint

 -> LayoutKit (2.0.0)

LayoutKit passed validation.
    ```
- [ ] Verify that all tests are passing.

    [![Build Status](https://travis-ci.org/linkedin/LayoutKit.svg?branch=master)](https://travis-ci.org/linkedin/LayoutKit)
- [ ] [Draft a release](https://github.com/linkedin/LayoutKit/releases) in Github and write release notes.
- [ ] Push the podspec to Cocoapods master repo.
    
    `pod trunk push`
- [ ] 👍
