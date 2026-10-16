// swift-tools-version:5.9
import PackageDescription

// 腾讯云智聆口语评测 SDK (QCloudSOE) 的 SwiftPM 封装。
// 由对应的 CocoaPods 配置翻译而来，版本与 Pod 严格一致：
//   - QCloudSOE   2.0.11  (static framework, 依赖 VoiceCommon, 链接 libc++)
//   - VoiceCommon 1.0.5   (static framework, 链接 libc++)
let package = Package(
    name: "QCloudSOE",
    platforms: [
        .iOS(.v12) // QCloudSOE podspec 要求 iOS 12.0（VoiceCommon 本身支持 9.0，取较高者）
    ],
    products: [
        // 一个 library 同时暴露两个二进制模块及 C++ 链接配置。
        // 集成后可直接 `import QCloudSOE` 与 `import VoiceCommon`。
        .library(
            name: "QCloudSOE",
            targets: ["QCloudSOE", "VoiceCommon", "QCloudSOECxxSupport"]
        ),
    ],
    targets: [
        // 预编译二进制（已是 xcframework，含真机 arm64 + 模拟器 arm64/x86_64）
        .binaryTarget(
            name: "QCloudSOE",
            path: "Frameworks/QCloudSOE.xcframework"
        ),
        .binaryTarget(
            name: "VoiceCommon",
            path: "Frameworks/VoiceCommon.xcframework"
        ),
        // 二进制 target 不能携带 linkerSettings，故用一个空的支撑 target
        // 把 podspec 里的 `libraries: "c++"` 还原为 -lc++ 链接标记。
        .target(
            name: "QCloudSOECxxSupport",
            dependencies: ["QCloudSOE", "VoiceCommon"],
            path: "Sources/QCloudSOECxxSupport",
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
    ]
)
