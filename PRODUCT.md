# Product

## Register

product

## Users

The Parlo team / app owner acting as administrators. Context: at a desk, in a web browser, doing
focused management and moderation work — not casual browsing. They want to scan, find, decide, and
act quickly across many users and reports.

## Product Purpose

A single web console to operate the live Parlo language-learning app: manage user accounts (view,
edit, disable, delete data), triage problem reports (complaints), monitor app/content ratings, and
read platform-health metrics at a glance. Success = an admin can answer "who is this user, what did
they report, is the app healthy?" in seconds, and take the right action without leaving the screen.

## Brand Personality

Calm, precise, trustworthy. Shares Parlo's product voice: the interface disappears into the task.
Three words: **clear, composed, dependable.** Emerald marks meaning (primary actions, current
selection, healthy state) — never decoration.

## Anti-references

- The default Flutter/Material starter look (raw `DataTable`, stock `NavigationRail`, generic cards).
- Gradient-drenched "SaaS dashboard" templates (hero-metric gradients, glassmorphism, neon).
- Cramped enterprise admin panels with no breathing room or hierarchy.

## Design Principles

1. **The tool disappears.** Earned familiarity over novelty; standard affordances, no invented ones.
2. **Colour = meaning.** Saturated colour rides on icons, primary actions, and status only.
3. **One vocabulary.** One card surface, one table surface, one status-pill, one button family —
   identical screen to screen.
4. **Dense, but breathing.** Show a lot per screen (it's an admin tool) with deliberate rhythm, not
   clutter.
5. **Every state is designed.** Default / hover / focus / loading / empty / error all exist.

## Accessibility & Inclusion

WCAG AA: body text ≥4.5:1, large text ≥3:1. Full keyboard navigation with visible focus rings.
Status never encoded by colour alone (always icon + label). Respect `prefers-reduced-motion`.
Light and dark themes both first-class.
