# Release 1.1 Checklist

## Product
- [ ] Verify roadmap order text is visible and accurate.
- [ ] Verify Guide cards open detailed guide pages.
- [ ] Verify IRA type selection (Roth vs Traditional) appears in onboarding and dashboard.
- [ ] Verify HSA can be toggled and edited in onboarding and dashboard.

## Analytics
- [ ] Confirm `roadmap_learn_open` events are firing.
- [ ] Confirm `roadmap_learn_more_tap` events are firing.
- [ ] Confirm `roadmap_step_completed` and `roadmap_step_uncompleted` events are firing.
- [ ] Confirm `guide_article_open` events are firing.

## Data + Migration
- [ ] Validate existing users without `iraType` default safely.
- [ ] Validate completed roadmap count ignores stale step IDs.
- [ ] Validate Firestore writes include `iraType` after changes.

## QA
- [ ] Run `flutter analyze` with zero new issues.
- [ ] Smoke test onboarding flow on Android.
- [ ] Smoke test dashboard quick-edit sheets.
- [ ] Verify no regression in currency input behavior.

## Play Store Prep
- [ ] Increment app version in `pubspec.yaml`.
- [ ] Build release AAB: `flutter build appbundle --release`.
- [ ] Confirm output exists at `build/app/outputs/bundle/release/app-release.aab`.
- [ ] Upload to internal testing track before production rollout.
