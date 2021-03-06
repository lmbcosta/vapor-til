// swift-tools-version:4.0
import PackageDescription

//let package = Package(
//    name: "TILApp",
//    dependencies: [
//        // 💧 A server-side Swift web framework.
//        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
//
//        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
//        //.package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0")
//
//        // MySQL
//        //.package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc")
//
//        // Postgres
//        .package(urls: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc")
//    ],
//    targets: [
//        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor"]),
//        .target(name: "Run", dependencies: ["App"]),
//        .testTarget(name: "AppTests", dependencies: ["App"])
//    ]
//)

//let package = Package(
//    name: "TILApp",
//    dependencies: [
//        .package(url: "https://github.com/vapor/vapor.git",
//                 from: "3.0.0"),
//        // 1
//        .package(url: "https://github.com/vapor/fluent-mysql.git",
//                 from: "3.0.0-rc")
//    ],
//    targets: [
//            .target(name: "App", dependencies: ["FluentMySQL", "Vapor"]),
//            .target(name: "Run", dependencies: ["App"]),
//            .testTarget(name: "AppTests", dependencies: ["App"]),
//            ]
//)

let package = Package(
    name: "TILApp",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),
    ],
    
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)
