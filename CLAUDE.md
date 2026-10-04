# Private Vault

An iOS app that stores files and media behind a passcode. Users import from the photo library, files, camera, document scanner, clipboard or the share extension, and organise items with folders and tags.

## Git

Never run `git commit` or `git push` without an explicit request from the user.

## Project Structure

The Xcode project is under `Project/`. The app target (`PrivateVault App/`) only holds `PrivateVaultApp.swift`, assets, sounds and the demo store used for screenshots. All code lives in Swift packages under `Project/Packages/`:

| Package | Role |
|---------|------|
| `Shared` | Non-UI helpers: demo launch-argument flags (`Constants.swift`) and `String.capping` |
| `SharedUI` | Reusable views, modifiers and representables (`ColorButton`, `RadioButton`, `SearchBarView`, `ShareSheet`, `.shake()`…), `SoundEffect`, `FeedbackGenerator` |
| `Persistence` | Core Data model and `StoredItem` / `Folder` / `Tag` classes, `PersistenceManager` (store setup and importing), `DiskStore`, `PreviewCache`, `SortMethod`, `PreviewEnvironment` |
| `Middleware` | State objects shared across features: `AppState`, `UserSettings`, `ItemFilter` |
| `ItemViews` | Item thumbnails and previews, `FolderShape`, `QuickLookView` |
| `LockScreen` | `LockView`, `SetPasscodeView`, keypad views, `PasscodeManager`, `LockoutManager` |
| `ImportScreens` | Camera, photo, document and scanner pickers, `FileTypePickerView` |
| `FolderEditor` | Create, edit and pick folders, `FolderNavigationView` |
| `ItemEditor` | `ItemEditView` |
| `Tags` | `FiltersView`, `ManageTagsView` |
| `Gallery` | `GalleryGridView`, cells, header and empty states |
| `Settings` | `SettingsView`, about, license and privacy screens |
| `Application` | Root `Application` view, `ContentView`, and `GalleryView` (the main screen, which presents every other feature) |

The app target links only `Application`. The `PrivateVault Import Action` share extension links only `Persistence`.

Dependencies point downwards: `Shared` / `Persistence` → `SharedUI` / `Middleware` → feature packages → `Application`. Feature packages do not depend on `Application`, and `Gallery` does not depend on `Settings`, `Tags`, `ItemEditor` or `ImportScreens`.

## Architecture Notes

- **State** is passed with `@EnvironmentObject` (`PersistenceManager`, `PasscodeManager`, `UserSettings`, `DiskStore`, `AppState`, `ItemFilter`), created in `Application.swift` and `ContentView.swift`.
- **Data** is read with `@FetchRequest` on the Core Data classes directly; writes go through `PersistenceManager`.
- **Core Data classes are hand-written** in `Persistence/Model/` because generated classes are not visible outside the package. When the model changes, update those classes too. The model is loaded from the package bundle in `PersistenceManager`.
- **Packages build in Swift 5 language mode** (`swiftLanguageMode(.v5)` in each `Package.swift`).
- **Shared helpers come from [ToolKit](https://github.com/EmilioPelaez/ToolKit) and CGMath first.** `Platform`, `.if`, `.extendHorizontally()`, `Bundle.main.version` and the `CGSize` helpers (`init(side:)`, `aspectRatio`, `*`, `/`) are used from there; check both before adding a local extension.
- **Images and sounds** stay in the app target and resolve from `Bundle.main`, so they do not appear in package previews.

## New Packages

Copy an existing `Package.swift`, set `name`, `localPackages` and `remotePackages`, and add the package to `Application`'s `localPackages`. Anything used from another package must be `public`, including view initialisers.

## Building and Testing

```bash
cd Project
xcodebuild build -project PrivateVault.xcodeproj -scheme PrivateVault \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' 2>&1 | /opt/homebrew/bin/xcsift
```

- Unit tests: scheme `PrivateVault`, `-only-testing:PrivateVaultTests`.
- UI tests: scheme `Screenshots`. They launch with the `Demo Content` argument, which opens the bundled demo store instead of the user's.

## Fastlane

Lanes are defined in `Project/fastlane/Fastfile`.
