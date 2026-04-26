# Adulti Ad Style Guide (For Remotion)

This document captures the visual style from the Flutter Adulti app so ad videos stay consistent with the product UI.

## Source of Truth

Primary source files:

- ../lib/app/theme.dart
- ../lib/widgets/shared/bento_card.dart
- ../lib/widgets/shared/mission_card.dart
- ../lib/widgets/shared/roadmap_step_card.dart
- ../lib/features/guide/guide_screen.dart
- ../lib/features/dashboard/dashboard_screen.dart

## Brand Personality

- Clean, optimistic, tactical-finance feel
- Light UI base with navy anchors and semantic accents
- Rounded cards and chips with subtle borders
- Calm motion: short fade + slight slide, not aggressive transitions

## Color Tokens

Core:

- background: #F8FAFC
- surface: #FFFFFF
- navy: #1E3A5F
- navyLight: #2D5282

Semantic:

- success: #22C55E
- warning: #F59E0B
- danger: #EF4444

Text:

- textPrimary: #0F172A
- textSecondary: #64748B
- textMuted: #94A3B8

Utility accents used in UI scenes:

- shadowBlue: #3B82F6
- shadowWisp: #FEF3C7
- shadowWispDeep: #F59E0B

Recommended ad usage split:

- 65% light surfaces/background
- 25% navy/navyLight structure
- 10% semantic accent highlights

## Typography

Font pairing:

- Headline/display: Space Grotesk
- Body/labels: Inter

Scale and weights:

- Display XL: 48 / 800 / tight tracking
- Display L: 36 / 700
- Display M: 28 / 700
- Headline: 24, 20, 18 / 700 to 600
- Body: 16, 14, 12 / 400
- Label: 14, 12, 10 / 500 to 700 for badges

Type behavior in ads:

- Headlines: bold, short, high contrast
- Body: neutral and readable, line-height around 1.45 to 1.5
- Badge/meta: uppercase with slight letter spacing

## Shape and Layout Tokens

Radii:

- Micro chip radius: 6 to 8
- Inputs/small controls: 12
- Buttons: 14
- Cards: 16
- Hero/logo blocks: 20 to 24
- Pills: 20 or fully rounded

Borders:

- Default border weight: 1.5
- Border color: navy at low opacity

Spacing rhythm:

- Base spacing: 4
- Common steps: 8, 10, 12, 14, 16, 20, 28
- Typical content horizontal padding: 20

## Surface and Elevation Style

Card recipe (Bento style):

- Surface fill: white
- Radius: 16
- Border: navy with low alpha
- Shadow: very subtle navy tint, low blur and low y-offset

Accent card variants:

- Tint card background with low alpha of accent color
- Increase border alpha for that accent
- Optional glow shadow for highlight moments

## Components to Mirror in Remotion Scenes

- Bento cards with clean borders and soft depth
- Priority badges (small, rounded, uppercase)
- Left accent rails for high-priority list items
- Compact icon tiles with rounded corners
- Bottom-sheet-like rounded panels for detail moments
- Navigation chip states: active = tinted navy background

## Motion Language

Global motion direction:

- Fade in + slight upward settle
- Durations mostly between 300ms and 500ms
- Ease-out curves for entrances

Do:

- Stagger card entrances by 60ms to 120ms
- Use brief emphasis glows for key financial milestones

Avoid:

- Long bouncy transitions
- Heavy blur/glass effects
- Dark dramatic palettes that break product continuity

## Remotion Implementation Notes

For ad compositions, define a shared style module with:

- color tokens
- typography presets
- radius and spacing constants
- reusable card, badge, and stat-chip style objects

When embedding phone demo video inside ad scenes:

- Keep phone frame and UI overlays in Adulti token colors
- Use rounded screen mask and restrained shadow
- Avoid color grading that alters token recognition

## QA Checklist Before Final Render

- Colors match token hex values
- Headings use Space Grotesk, body uses Inter
- Card corners and borders match app style
- Motion is subtle and readable
- Accent usage stays semantic (green success, amber warning, red danger)
- Scene feels like Adulti product marketing, not a generic template
