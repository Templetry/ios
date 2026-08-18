import Foundation

/// The active environment profile.
///
/// Xcode's own mechanism: one build configuration per environment, each
/// setting its own `SWIFT_ACTIVE_COMPILATION_CONDITIONS` in `project.yml`.
/// The selection is therefore a compile-time fact — there is no plist to
/// misconfigure and nothing to read at launch.
enum AppConfig {
    #if ENV_PRODUCTION
    static let current: AppEnvironment = .production
    #elseif ENV_STAGING
    static let current: AppEnvironment = .staging
    #elseif ENV_DEVELOPMENT
    static let current: AppEnvironment = .development
    #else
    // Deliberately a build failure rather than a default. If the build
    // settings ever stop reaching the compiler, silently shipping the
    // development profile to production is the worst possible outcome.
    #error("No environment compilation condition is set. Check SWIFT_ACTIVE_COMPILATION_CONDITIONS in project.yml.")
    #endif
}
