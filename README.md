# Quick Share / Smart Posts

Quick Share is a Flutter implementation of a Smart Posts sharing flow for
beauty consultants. It demonstrates a vertical snapping feed, editable sales
captions, delayed product context, a multi-platform share action, and a dark
checklist launch experience, all built as a compact single-screen assignment
with clear separation between data, state, and presentation.

## Demo

### Full Walkthrough
![Full Walkthrough](assets/demo/walkthrough.gif)

### Part 2
![Part 2](assets/demo/part2.gif)

### Part 3
![Part 3](assets/demo/part3.gif)

## How To Run

Prerequisites:

- Flutter SDK installed and available on `PATH`
- A mobile emulator, simulator, or connected device
- Optional: Chrome or another Flutter-supported browser for web

Install dependencies:

```bash
flutter pub get
```

Run on a mobile emulator, simulator, or device:

```bash
flutter run
```

Run on web:

```bash
flutter run -d chrome
```

Run the full test suite:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Architecture

The codebase is split into small layers that keep responsibilities explicit:

- `lib/core`: design tokens, color constants, typography, dimensions, and theme
  setup.
- `lib/domain`: immutable entities that describe posts, products, platforms,
  share steps, referral details, and checklist rows.
- `lib/data`: repository abstraction plus the mock repository used by the app.
- `lib/logic`: plain `ChangeNotifier` controllers for feed position, captions,
  product overlay timing, share progress, and checklist state.
- `lib/presentation`: screens, routes, widgets, and small UI services.

The implementation follows SOLID principles by keeping UI widgets focused on
rendering and user input while controller classes own state transitions.

Dependency inversion is handled through the `PostRepository` abstraction, so the
screen depends on a contract instead of concrete data construction.

Controllers are plain, testable `ChangeNotifier` state machines. Timing values
are injectable, and timers live in controllers rather than being buried inside
widgets.

## State Management

The app uses Flutter primitives: `ChangeNotifier`, `ValueNotifier`, and
`ListenableBuilder`.

No third-party state management package is used. For this assignment's
single-screen scope, Flutter's built-in listenable model keeps the dependency
surface small and makes ownership easy to inspect.

Stateful behavior is still kept out of the widget tree where it matters. The
caption editor, product overlay delay, share flow, checklist animation, and feed
index all have controller-level tests or widget-level coverage.

Timing-based logic is tested with injectable durations and `fake_async`, which
keeps delayed behavior deterministic without waiting for real time.

## Testing

The test suite covers controller state machines and user-facing widget flows.

Controller coverage includes:

- Caption draft validation and save behavior
- Feed index changes
- Product overlay delayed appearance and reset behavior
- Share progress phase changes, step advancement, redirect timing, and finish
- Checklist step completion timing

Widget coverage includes:

- Quick Share screen feed chrome
- Edit caption route behavior and save-button enablement
- Share flow progress overlay and redirect splash behavior
- Checklist completion flow into the Quick Share screen
- Caption expansion regression coverage for keeping the edit footer tappable

Run all tests with:

```bash
flutter test
```

## Assumptions And Design Decisions

- Oriflame Sans 2.0 is proprietary, so Satoshi, called out in the design spec,
  stands in for all text in this build.
- The ORIFLAME wordmark is rendered as styled text because no logo asset was
  included in the export.
- The avatar is an initials placeholder because no avatar asset was included in
  the export.
- Redirect after sharing is simulated with a per-platform splash screen. Meta
  branding is shown only for Instagram, Facebook, and Messenger.
- No real deep links are opened, matching the assignment guidance for a mocked
  share handoff.
- The product overlay appears automatically 3 seconds after landing on a card.
- The product overlay timer resets on vertical swipe to a new post.
- The checklist screen is the launch experience, interpreting the Smart Posts
  preparation flow from the spec.
- The checklist is replayable by tapping `Your Assistant`.
- The camera tab and other inactive bottom-nav tabs are visual only, matching
  the single-page scope of the assignment.
- Brand logos were fetched as SVGs for visual fidelity.
- Product imagery is local and bundled under `assets/images`.
- The feed contains three mocked posts to demonstrate snapping, pagination, and
  per-card caption state.
- Share progress is simulated with deterministic controller steps rather than
  remote calls.
- The edit caption surface is a pushed modal-style route so the feed remains
  intact underneath the editing task.

## Creative Touches

- Per-platform splash screens after the share flow completes
- Meta footer treatment for Instagram, Facebook, and Messenger
- Animated blur backdrop behind the share progress dialog
- Spinner-to-checkmark pop animation in the launch checklist
- Staggered checklist reveal before entering the feed
- Animated pagination dots for the vertical feed
- Haptic feedback on feed swipe and share redirect
- Slide-up modal route for editing captions
- `AnimatedSize` for the expandable caption card
- Product overlay that auto-appears after dwell time
- Platform-specific share chips with business-account treatment
- Dark launch screen that contrasts with the brighter feed UI
- Scrollable expanded caption body so the footer action remains reachable

## Notable Files

- `lib/presentation/screens/smart_post_checklist_screen.dart`: launch checklist
  flow.
- `lib/presentation/screens/quick_share_screen.dart`: main feed composition and
  routing.
- `lib/presentation/screens/edit_caption_screen.dart`: caption editing route.
- `lib/presentation/widgets/feed_card.dart`: vertical feed card layout.
- `lib/presentation/widgets/caption_card.dart`: expandable caption card and edit
  footer.
- `lib/presentation/widgets/share_progress_overlay.dart`: share progress dialog
  and blur backdrop.
- `lib/logic/share_flow_controller.dart`: share phase state machine.
- `lib/logic/product_overlay_controller.dart`: delayed product overlay timing.
- `test/`: controller and widget tests for the assignment behavior.

## Scope Boundaries

This is an interview assignment build, not a production social publishing
client. It focuses on the intended interaction model, visual fidelity, state
coordination, and testability.

The app does not authenticate users, upload content, call remote APIs, or open
external apps. Those integration points are represented by mocked data and local
transitions so the core product experience can be reviewed quickly.
