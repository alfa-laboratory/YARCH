<p align="center">
  <img src="https://i.imgur.com/ZcxzsEg.png" width="281.5" height="103"/>
</p>

[![Platform](https://img.shields.io/badge/platform-iOS-green.svg)]()
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Build Status](https://travis-ci.org/alfa-laboratory/YARCH.svg?branch=master)](https://travis-ci.org/alfa-laboratory/YARCH)
[![codecov](https://codecov.io/gh/alfa-laboratory/YARCH/branch/master/graph/badge.svg)](https://codecov.io/gh/alfa-laboratory/YARCH)
![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

YARCH is an architecture pattern developed primarly for iOS applications. You can ask any questions in our [telegram](https://t.me/yarch_ios) channel.

[Russian version](README-rus.md) of the readme.

## Overview
![](YARCH-scheme.png)

[Here](GUIDE.md) you can read more about YARCH components.

## How to create a new module

We are using [generamba](https://github.com/rambler-digital-solutions/Generamba) for the module code generation. Our catalog:
```
https://github.com/alfa-laboratory/YARCH-Template
```

To create a new module in the example project you need to install generamba templates:
```
generamba template install
```

To create a new module you need to run following command in the terminal:
```
generamba gen [MODULE_NAME] yarch --description 'Purpose of your module.'
```

License
--------

© 2017 Alfa-Bank. MIT.
