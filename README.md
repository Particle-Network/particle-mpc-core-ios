# Particle Auth Core

[![Swift](https://img.shields.io/badge/Swift-5.7-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)](https://img.shields.io/badge/Platforms-iOS-Green)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ParticleAuthCore.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![License](https://img.shields.io/github/license/Particle-Network/particle-ios)](https://github.com/Particle-Network/particle-mpc-core-ios/blob/main/LICENSE.txt)


This repository contains [Auth Core](https://docs.particle.network/developers/auth-service/core/ios) sample source. It supports Solana and all EVM-compatiable chains now, more chains and more features coming soon! Learn more visit [Particle Network](https://docs.particle.network/).

# Prerequisites
Install the following:

Xcode 15.0 or higher

### Note
Please note that the SDK supports `ios-arm64` (iOS devices). We currently do not support simulators. To perform testing, you will require an actual iPhone device.


| Xcode version                | 15.0 or higher | 
|------------------------------|---------------|
| ParticleAuthCore             | 1.4.10        |
| ParticleMPCCore              | 1.4.10        |
| AuthCoreAdapter              | 1.4.10        |
| Thresh                       | 1.4.10        |

## 🎯 Support Apple Privacy Manifests
From version 1.4.0, all SDKs have been adapted to Apple's privacy requirements.

The following third-party SDKs require the use of specific versions.
```ruby
pod 'SwiftyUserDefaults', :git => 'https://github.com/SunZhiC/SwiftyUserDefaults.git', :branch => 'master'
pod 'SkeletonView', :git => 'https://github.com/SunZhiC/SkeletonView.git', :branch => 'main'
```


###  🧂 Update Podfile
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
   end
```

Make sure that your project meets the following requirements:

Your project must target these platform versions or later:

iOS 14

## 🔧 Getting Started

* Clone the repo. open Demo folder.
* Replace ParticelNetwork.info with your project info in the [Dashboard](https://dashboard.particle.network/#/login).
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PROJECT_UUID</key>
	<string>YOUR_PROJECT_UUID</string>
	<key>PROJECT_CLIENT_KEY</key>
	<string>YOUR_PROJECT_CLIENT_KEY</string>
	<key>PROJECT_APP_UUID</key>
	<string>YOUR_PROJECT_APP_UUID</string>
</dict>
</plist>

```

* Add Privacy - Face ID Usage Description to your info.plist file

## 💿 Build
```
pod install --repo-update
```

## 🔬 Features

1. Auth login with JWT.
2. Logout.
3. Sign.
4. Change master password.

## 📄 Docs
1. https://docs.particle.network/developers/auth-service/core/ios


## 💼 Give Feedback
Please report bugs or issues to [particle-ios/issues](https://github.com/Particle-Network/particle-mpc-core-ios/issues)
◊
You can also join our [Discord](https://discord.gg/2y44qr6CR2).


