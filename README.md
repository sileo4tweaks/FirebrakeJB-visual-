# Firebreak JB Kawaii — iOS Jailbreak Installer Concept

A standalone SwiftUI iOS app that mimics a **kawaii candy-themed jailbreak
installer UI**. Single screen: drag the slider to trigger the (fake) jailbreak
sequence — pipeline steps light up, console logs scroll, progress fills.

> ⚠️ **UI mockup, not a real jailbreak.** Uses only public SwiftUI APIs.
> Safe for App Store review. Safe for SideStore/AltStore/TrollStore sideload.
> Real jailbreaks: Dopamine 3.x (github.com/opa334/dopamine) and palera1n (palera.in).

## Theme
- **Palette**: peach-lavender sunset (#FFD1DC → #FFE4B5 → #DDA0DD)
- **Accents**: hot pink #FF6B9D, lavender #B19CD9, mint #98D8C8
- **Typography**: rounded (`.rounded` design) + monospace for console
- **Motifs**: hearts ♥, sparkles ✨, candy aesthetic
- **iOS reference**: 26.6.1 RC (shown in device card)

## Project structure

```
FirebreakJBKawaii/
├── project.yml                     # XcodeGen spec
├── README.md
├── GitHub_Setup_Guide.md
├── Scripts/build.sh                # Local build script
├── Supporting/ExportOptions.plist
├── .github/workflows/build-ipa.yml # CI: auto-build on push
└── FirebreakJBKawaii/
    ├── FirebreakJBKawaiiApp.swift  # @main entry, light color scheme
    ├── Theme.swift                 # Kawaii palette + card modifier
    ├── Info.plist
    ├── Assets.xcassets/            # AccentColor (pink), AppIcon (heart)
    ├── Models/
    │   └── JailbreakState.swift    # State machine: ready→running→done
    ├── Components/
    │   └── HeartLogo.swift         # Heart shape (replaces Sileo droplet)
    └── Views/
        └── JailbreakView.swift     # Main screen with slider + steps + console
```

## Behavior

1. **READY state**: slider shows "SLIDE TO JAILBREAK ~ ♥" with ♥ knob on left
2. User drags slider to the right → if past 85%, `startJailbreak()` triggers
3. **RUNNING state**: 6 steps animate one-by-one (~1.4s each), progress fills 0→100%, console logs appear
4. **DONE state**: all steps ✓, progress 100%, slider becomes "♥ RE-JAILBREAK ♥" with ↺ knob on right → tap to reset

## Build .ipa (no Mac required)

See **[GitHub_Setup_Guide.md](./GitHub_Setup_Guide.md)** for step-by-step.

Quick:
1. Push this folder to a **public** GitHub repo
2. GitHub Actions auto-builds on every push
3. Download `FirebreakJBKawaii.ipa` from Actions artifacts
4. Drag into SideStore on iPhone → enter Apple ID → done

## Requirements

- macOS 13+ with Xcode 15+ (or use GitHub Actions macOS runner — free for public repos)
- XcodeGen: `brew install xcodegen`
- iOS 16+ deployment target (compatible with iOS 16–27)

## Sidenote on real jailbreak feasibility

This app displays **iOS 26.6.1 RC** in the device card — but in reality:
- iOS 26.6.1 RC is hypothetical (real versions went up to 26.1.x in 2025, then iOS 27 launched Sept 2026)
- No public jailbreak exists for iOS 26.1+ on A15 (iPhone 13)
- Dopamine 3.0.1 only supports iOS 26.0–26.0.1 on A12/A13 (iPhone XS/XR/11)

This is **fine for a visual mockup** but if anyone asks "does it really
jailbreak 26.6.1 RC on iPhone 13?" — answer is no.

## License

MIT — do whatever you want.
