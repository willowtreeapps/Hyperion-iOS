import PackageDescription

let package = Package(
  name: "Hyperion-iOS",
  platforms: [
     .iOS(.v9)
  ],
  products: [
    .library(
      name: "Hyperion-iOS",
      targets: ["HyperionCore", "SlowAnimations", "Measurements", "AttributesInspector"]
    )
  ],
  targets: [
    .target(name: "HyperionCore"),
    .target(name: "SlowAnimations"),
    .target(name: "Measurements"),
    .target(name: "AttributesInspector")
  ]
)