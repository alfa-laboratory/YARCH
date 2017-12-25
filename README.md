<p align="center">
  <img src="https://i.imgur.com/ZcxzsEg.png" width="281.5" height="103"/>
</p>

[![Build Status](https://travis-ci.org/alfa-laboratory/YARCH-Examples.svg?branch=master)](https://travis-ci.org/alfa-laboratory/YARCH-Examples)
[![codecov](https://codecov.io/gh/alfa-laboratory/YARCH-Examples/branch/master/graph/badge.svg)](https://codecov.io/gh/alfa-laboratory/YARCH-Examples)

YARCH is an architecture pattern developed primarly for iOS applications. You can ask any questions in our [telegram](https://t.me/yarch_ios) channel.

[Russian version](https://github.com/alfa-laboratory/YARCH-Examples/blob/master/README-rus.md) of the readme.

## Overview
![](YARCH-scheme.png)

[Here](https://github.com/alfa-laboratory/YARCH-Examples/blob/master/GUIDE.md) you can read more about YARCH components.

## First launch

We are using [CocoaPods](https://cocoapods.org). If you haven't CocoaPods installed you can install it with the terminal command:

```
sudo gem install cocoapods
```

Open the project folder in the terminal and run next command:


```
pod repo update && pod install
```

Now you can open `.xcworkspace` file to launch the project.

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
