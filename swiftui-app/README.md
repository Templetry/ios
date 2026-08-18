# TemplateApp

SwiftUI app for iOS 17+. The Xcode project is **generated**, view models are plain `@Observable` types, and everything worth testing lives outside a `View`.

## Open it

```sh
brew install xcodegen
xcodegen generate
open TemplateApp.xcodeproj
```

`*.xcodeproj` is gitignored on purpose. A `project.pbxproj` is a merge-conflict machine that nobody reviews; [`project.yml`](project.yml) is fifty readable lines that produce it.

## Test

From Xcode (⌘U), or:

```sh
xcodebuild test -scheme TemplateApp -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Layout

```
project.yml                  the Xcode project, as a spec
Sources/TemplateApp/
  TemplateAppApp.swift       @main
  ContentView.swift          the tab shell
  Support/Welcome.swift      a rule with no SwiftUI in it
  Config/                    the environment profiles
  Views/                     screens
  Models/                    @Model types
  Networking/                the API client and its view model
Tests/TemplateAppTests/
```

## How this is meant to be extended

**Put behaviour where a test can reach it.** `Welcome` is a struct that takes its clock; `GreetingViewModel` takes its client. Neither needs a simulator or a network to be tested, and that is the reason they are shaped that way rather than living inside their views.

`sources` in `project.yml` globs the directory, so a new file is in the target as soon as it exists — no project edit, no merge conflict.

## Environment profiles

`development`, `staging` and `production` are Xcode **build configurations** (ADR-0018) — the ecosystem's own mechanism. Development is a debug build; the other two are release builds, which is what makes staging genuinely production-like.

Each configuration sets its own `SWIFT_ACTIVE_COMPILATION_CONDITIONS`, and `AppConfig.current` picks the active profile with `#if`. If a configuration ever loses its flag, `AppConfig` raises `#error` and the build fails — deliberately, because silently shipping the development profile to production is the worst available outcome.

```sh
xcodebuild build -scheme TemplateApp -configuration Staging \
  -destination 'generic/platform=iOS Simulator'
```

`AppEnvironment` holds all three profiles as plain data, so the test suite asserts every one of them in a single run rather than only whichever was compiled.

## Notes

- **Swift 5 language mode.** Moving to 6 (`SWIFT_VERSION: "6.0"`) makes strict concurrency checking an error rather than a warning; that is a migration to do deliberately.
- **`templetry verify` does not work on this form**, and says so. Verification renders a template and builds it in a Docker container ([ADR-0004](https://github.com/Templetry/wiki/blob/main/adr/0004-verify-in-containers.md)); an iOS build needs macOS with Xcode. The parent's CI builds and tests it on a macOS runner instead.
