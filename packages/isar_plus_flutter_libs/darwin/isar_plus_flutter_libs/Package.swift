// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "isar_plus_flutter_libs",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "isar-plus-flutter-libs",
            targets: ["isar_plus_flutter_libs"]
        )
    ],
    targets: [
        // IsarPlusCore.framework is a *dynamic* framework, so its exported
        // symbols survive `xcodebuild archive` and stay resolvable from Dart.
        // Xcode embeds and signs it into the host app's Frameworks directory.
        .binaryTarget(
            name: "isar_plus_core",
            // Self-built and hosted on this fork (see
            // v1.3.9-kechankrisna.3 release) — the raw git checkout never
            // runs isar_plus's own CI release pipeline that would normally
            // fill this in, so it's done by hand. Built locally from the
            // same source as v1.3.9-kechankrisna.2's Dart-side fixes via
            // `tool/build_darwin.sh`, with exported-symbol verification
            // passing (104 isar_plus_* symbols per slice).
            url: "https://github.com/kechankrisna/isar_plus/releases/download/v1.3.9-kechankrisna.3/isar_plus_core.xcframework.zip",
            checksum: "c91cd817479b29dd230ba574e829a5432a3688eb1f69cd49a634e7127ba514dc"
        ),
        // Exposes the few Core entry points the plugin itself calls to Swift.
        // The full FFI surface is bound from Dart, not from here.
        .target(
            name: "CIsarCore",
            dependencies: ["isar_plus_core"],
            path: "Core",
            publicHeadersPath: "include"
        ),
        .target(
            name: "isar_plus_flutter_libs",
            dependencies: ["CIsarCore"],
            path: "Plugin"
        ),
    ]
)
