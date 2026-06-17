# Parlo Admin — Design System

**Register:** product UI (design *serves* the task). Bar = **earned familiarity** — it should read
like Linear/Stripe/Notion-grade admin tooling, not a default Material app. Inherits Parlo's tokens
so the dashboard feels like the same product as the mobile app.

## Tokens (source of truth — never hard-code)

| Group | File | Notes |
|---|---|---|
| Colour | `lib/core/theme/app_colors.dart` | `primary` emerald `#16A34A`; `success/warning/error/info`; `accentBlue/Purple/Orange`; surfaces; `onSurfaceVariant` for muted text |
| Spacing | `lib/core/theme/app_spacing.dart` | 8-pt scale: `xs 4 · sm 8 · md 16 · lg 24 · xl 32 · xxl 48` |
| Radius | `lib/core/theme/app_radius.dart` | `sm 4 · md 8 · lg 16 (cards) · xl 24 · full` |
| Sizes | `lib/core/theme/app_sizes.dart` | icon / nav sizes |
| Type | `Theme.of(context).textTheme` (M3) | one family, fixed rem-style scale; weight for emphasis, not magic sizes |

## Surfaces & components (use these; don't re-roll chrome)

- **`AppCard`** (`core/ui/widgets/app_card.dart`) — the one card surface: radius `lg`, hairline
  `outlineVariant` border, ripple only when tappable. Hover-lifts when `onTap` is set.
- **`ConsoleTable` + `ConsoleRow`** (`core/ui/widgets/console_table.dart`) — the one list/table
  surface: a single bordered card with a muted header row and hairline row dividers; each row
  highlights on hover. Replaces stacked, gapped cards for any tabular list (users, complaints,
  ratings).
- **`StatCard`** (`core/ui/widgets/stat_card.dart`) — KPI tile: icon chip + big value + label,
  hover-lift, optional `onTap`.
- **`StatusBadge`** (`core/ui/widgets/status_badge.dart`) — status pill: 12 %-tint of its colour,
  always **icon + label** (never colour alone).
- **`PageHeader`**, **`SearchField`**, **`EmptyState`**, **`AsyncValueView`**, **`ActionButton`**,
  **`AppSnackBar`** — shared.

## Layout

- **App shell**: fixed left sidebar (`AdminShell`) + content. Sidebar is custom nav tiles (selected
  = filled-emerald-tint pill, hover = subtle surface tint), brand at top, admin chip + theme + sign
  out at the bottom. Collapses to icon-only below 1100 px.
- **Content** sits on the muted `background` canvas, capped at a max readable width (~1180 px) and
  left-aligned, so wide monitors don't stretch tables to noise.
- Responsive behaviour is **structural** (collapse sidebar, stack chart columns), not fluid type.

## Conventions

- **Colour = meaning.** Emerald only on primary actions, current nav, healthy/active state. Inactive
  surfaces stay neutral; muted text uses `onSurfaceVariant`.
- **Hierarchy by emphasis.** Page title (headlineSmall, bold) → section title (titleMedium) → row
  title (titleSmall) → meta (bodySmall, muted). Numbers in tables/KPIs are tabular and bold.
- **Motion** conveys state only, 150–200 ms ease-out: hover tints, row highlight, card lift. No
  decorative choreography, no page-load sequences.
- **Density with rhythm.** Table rows ~52 px, comfortable but scannable. Touch targets ≥44 px.
- **Every state designed.** Loading (spinner/skeleton), empty (teaching `EmptyState`), error
  (`AsyncValueView`), hover, focus.

## Absolute bans (anti-slop)

- Side-stripe (coloured left-border) accents — use a leading icon chip or full hairline border.
- Gradient text; glassmorphism as default; hero-metric gradient cards; raw Material `DataTable`.
- Stacked gapped cards as a "table" — use `ConsoleTable`.
- Stock `NavigationRail` chrome — use the custom sidebar tiles.
- Magic numbers instead of tokens; inconsistent component vocabulary across screens.
