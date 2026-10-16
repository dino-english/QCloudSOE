# QCloudSOE (SwiftPM 封装)

把腾讯云**智聆口语评测 SDK** 从 CocoaPods 配置翻译成的本地 Swift Package。

| 组件 | 版本 | 说明 |
|---|---|---|
| QCloudSOE | **2.0.11** | 口语评测主库（静态 xcframework，依赖 VoiceCommon） |
| VoiceCommon | **1.0.5** | 腾讯云语音基础库（静态 xcframework） |

> 版本与原 Podfile 一致：`QCloudSOE 2.0.11` + `VoiceCommon 1.0.5`。
> 二者均链接 `libc++`（已在包内通过支撑 target 自动处理，无需手动配置）。

## 平台与架构

- 最低版本：iOS 12.0
- 真机：`arm64`
- 模拟器：`arm64` + `x86_64`

## 引用方式

### 方式一：本地路径引用（当前形态）

在你的 `Package.swift`：

```swift
dependencies: [
    .package(path: "../swift-packages/QCloudSOE"),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "QCloudSOE", package: "QCloudSOE"),
        ]
    ),
]
```

Xcode 工程则用 `File > Add Package Dependencies… > Add Local…` 选择本目录，
然后在 target 的 *Frameworks, Libraries* 里勾选 `QCloudSOE`。

### 方式二：发到 Git 仓库后远程引用

把本目录推到 Git 并打 tag（建议 `2.0.11` 对齐主库版本）：

```swift
.package(url: "<your-git-url>/QCloudSOE.git", exact: "2.0.11")
```

## 使用

`QCloudSOE` product 同时暴露两个模块：

```swift
import QCloudSOE
import VoiceCommon   // 日志等基础能力
```

Objective-C：

```objc
#import <QCloudSOE/QCloudSOE.h>
#import <QCloudSOE/TAIOralConfig.h>
#import <VoiceCommon/QCloudVoiceLogger.h>
```

## 目录结构

```
QCloudSOE/
├── Package.swift
├── Frameworks/
│   ├── QCloudSOE.xcframework      # 2.0.11
│   └── VoiceCommon.xcframework    # 1.0.5
└── Sources/
    └── QCloudSOECxxSupport/       # 仅用于链接 libc++，无业务代码
        └── Empty.swift
```

## 与 CocoaPods 配置的对应关系

| podspec 字段 | SPM 还原方式 |
|---|---|
| `vendored_frameworks: *.xcframework` | `.binaryTarget(path:)` |
| `static_framework: true` | xcframework 本身即静态库，直接链接 |
| `libraries: "c++"` | 支撑 target 的 `.linkedLibrary("c++")` |
| `dependencies: VoiceCommon` | 两个二进制 target 同列入 `QCloudSOE` product |
| `platforms.ios = 12.0` | `platforms: [.iOS(.v12)]` |

## 二进制来源

- QCloudSOE: `https://sdk-1300466766.cos.ap-shanghai.myqcloud.com/soe_sdk/QCloudSOE_iOS_v2.0.10.zip`
- VoiceCommon: `https://sdk-1300466766.cos.ap-shanghai.myqcloud.com/asr_sdk/VoiceCommon_iOS_1.0.5.zip`

## 验证

已用 `xcodebuild -scheme QCloudSOE -destination 'generic/platform=iOS Simulator'`
编译通过（**BUILD SUCCEEDED**），manifest 解析正常。
