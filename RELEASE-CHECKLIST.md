# Release checklist

How to release a new version of LayoutKit.

- Verify that all tests are passing.

    [![Build Status](https://travis-ci.org/linkedin/LayoutKit.svg?branch=master)](https://travis-ci.org/linkedin/LayoutKit)

- Bump version in `LayoutKit.podspec` and `LayoutKitObjC.podspec`.

    `spec.version          = '2.0.0'`

- Bump the version in `Sources/Info.plist`

    ```
    <key>CFBundleShortVersionString</key>
    <string>2.0.0</string>
    ```
    
- Verify that the podspec is valid.

    ```
    $ pod lib lint

     -> LayoutKit (2.0.0)

    LayoutKit passed validation.
    ```

- Push version bumps to GitHub
- [Draft a release](https://github.com/linkedin/LayoutKit/releases) in Github and write release notes.
- Deploy the documentation

    ```bash
    $ mkdocs gh-deploy --clean
    INFO    -  Cleaning site directory 
    INFO    -  Building documentation to directory: /Users/nsnyder/code/linkedin/layoutkit-opensource/site 
    INFO    -  Copying '/Users/nsnyder/code/linkedin/layoutkit-opensource/site' to 'gh-pages' branch and pushing to GitHub. 
    INFO    -  Based on your CNAME file, your documentation should be available shortly at: http://layoutkit.org 
    INFO    -  NOTE: Your DNS records must be configured appropriately for your CNAME URL to work. 
    ```
    
- Push the podspec to Cocoapods master repo.
    
    `$ pod trunk push`

- 👍

# Required release tools

- cocoapods (try beta if cocoapods have any issues) 

    `$ sudo gem install cocoapods`

- mkdocs

    `$ brew install mkdocs`

