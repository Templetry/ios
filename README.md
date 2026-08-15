# Templetry parent: ios

iOS templates for [Templetry](https://github.com/Templetry). One **parent repo**, multiple **forms** — each form is a subdirectory that compiles on its own and carries its own `template.yml` ([ADR-0011](https://github.com/Templetry/wiki/blob/main/adr/0011-template-forms.md)).

| Form | What it is | Status |
|---|---|---|
| [`swiftui-app/`](swiftui-app/) | SwiftUI app — XcodeGen project, `@Observable` view models, optional SwiftData and async/await networking, XCTest | 🚧 awaiting first green CI |

## Usage

```sh
templetry init ios/swiftui-app --out ./my-app \
  --set "project_name=My App" --set "bundle_prefix=com.me"
```

Forms are **chosen**, not combined. Inside a form, the manifest's features are freely combinable.

## Two things that are different here

**The Xcode project is generated.** Forms ship a [XcodeGen](https://github.com/yonaskolb/XcodeGen) `project.yml` and gitignore `*.xcodeproj`. A `project.pbxproj` is a merge-conflict machine that nobody reviews, and it does not survive renaming cleanly — which a template has to do. `xcodegen generate` after cloning, and the file globs its sources, so a feature that adds or removes files needs no project edit.

**`templetry verify` does not apply.** Verification renders a template and builds it inside a Docker container ([ADR-0004](https://github.com/Templetry/wiki/blob/main/adr/0004-verify-in-containers.md)); an iOS build needs macOS with Xcode. These forms declare no `verify` block, and the CLI and the desktop both say so rather than pretending. The parent's CI builds and tests every form on a macOS runner instead — the guarantee is the same, it just cannot run on your laptop unless your laptop is a Mac.
