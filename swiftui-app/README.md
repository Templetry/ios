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
  Views/                     screens
  Models/                    @Model types
  Networking/                the API client and its view model
Tests/TemplateAppTests/
```

## How this is meant to be extended

**Put behaviour where a test can reach it.** `Welcome` is a struct that takes its clock; `GreetingViewModel` takes its client. Neither needs a simulator or a network to be tested, and that is the reason they are shaped that way rather than living inside their views.

`sources` in `project.yml` globs the directory, so a new file is in the target as soon as it exists — no project edit, no merge conflict.

## Notes

- **Swift 5 language mode.** Moving to 6 (`SWIFT_VERSION: "6.0"`) makes strict concurrency checking an error rather than a warning; that is a migration to do deliberately.
- **`templetry verify` does not work on this form**, and says so. Verification renders a template and builds it in a Docker container ([ADR-0004](https://github.com/Templetry/wiki/blob/main/adr/0004-verify-in-containers.md)); an iOS build needs macOS with Xcode. The parent's CI builds and tests it on a macOS runner instead.
