# AGENTS

Operating contract for AI agents and automation helpers working in this project.

## Mission

- Keep this a plain SwiftUI app: `@Observable` view models, value types where possible, no architecture framework until the app actually needs one.

## Core Rules

- **Never edit `*.xcodeproj`.** It is generated from `project.yml` by `xcodegen generate` and is gitignored. Change the spec, regenerate.
- New source files need no project change — `sources` globs the directory.
- Logic that can be tested must not live inside a `View`. Give a type its clock, its client, its dependencies; do not reach for singletons from a view body.
- Networking goes through the `APIClient` protocol so tests can answer from memory. Do not add `URLSession` calls directly to a view or view model.
- SwiftData tests use an in-memory `ModelContainer`, never the app's store.
- Error states shown to a person say what happened; do not surface `error.localizedDescription` as the UI.
- Every non-`View` type gets an XCTest case.
- Update docs in the same change when behavior or process changes.

## Required Checks Before Finishing

- `xcodegen generate` succeeds.
- `xcodebuild build-for-testing -scheme TemplateApp -destination 'generic/platform=iOS Simulator'` compiles clean.
- The test suite passes on a simulator.

```sh templetry:checks
xcodegen generate
xcodebuild build -scheme TemplateApp -destination 'generic/platform=iOS Simulator'
```

## Safe Change Workflow

1. Read the affected files fully before editing.
2. Make the smallest change that solves the task.
3. Build and test, then review the diff with git before committing.

## This project came from a template

Four facts you cannot infer from the code in front of you:

- **Never hand-edit `.templetry-answers.yml`.** It records what generated this project. Editing it makes the next update merge against a state that never existed.
- **Before writing a capability by hand, run `templetry pieces`.** Auth, RBAC, audit trails, API keys and whole CRUD resources may already exist as pieces for this template. Adopting one is `templetry add <name>`, and it brings its own tests.
- **`templetry update` pulls improvements from the template** through a three-way merge that keeps your edits. Use it instead of copying files from the template by hand.
- **Directives like `tpl:if` belong to the template, not here.** If you find one in this project, it is a rendering bug worth reporting — do not try to interpret it.
