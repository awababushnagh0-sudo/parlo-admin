# Parlo Admin

A Flutter **Web** dashboard for administering the Parlo language-learning app. It connects to the
**same Firebase project** as the mobile app (`parlo-ec41a`) and lets an administrator:

- **Dashboard** — KPIs (total users, new this month, open complaints, average rating) and charts
  (signups over the last 6 months, rating distribution).
- **Users** — list/search every user, open a detail view (profile, streak/XP stats, saved
  words/sentences/videos counts), edit the display name, **disable** (soft-ban) or **delete** a
  user's data.
- **Complaints** — review problem reports submitted from the mobile app, filter by status, and
  mark them resolved / dismissed / reopened with an internal note.
- **Ratings** — see the average rating, star distribution, and every individual rating + comment.

It mirrors the mobile app's clean architecture: feature-based `core` + `features/<feature>/{domain,data,presentation}`, Riverpod for state/DI, `go_router`, `slang` for i18n, manual Firestore (de)serialization, and the same theme tokens.

## Architecture

```
lib/
  core/            config · l10n (slang) · providers · routers (app_router + shell) · services · theme · ui
  features/
    auth/          email+password sign-in, gated by the admins/{uid} registry
    dashboard/     KPI + chart overview
    users/         CRUD over the users collection + subcollections
    complaints/    moderation over the top-level complaints collection
    ratings/       overview over the top-level ratings collection
```

## Firestore data model (shared with the mobile app)

Top-level collections:

| Collection        | Shape |
|-------------------|-------|
| `admins/{uid}`    | `{ email, addedAt }` — presence grants admin access |
| `ratings/{id}`    | `{ userId, userEmail, type, targetId?, stars, comment?, appVersion?, createdAt }` |
| `complaints/{id}` | `{ userId, userEmail, category, targetType, targetId?, message, status, adminNote?, createdAt, resolvedAt? }` |

The per-user tree (`users/{uid}` + `words`/`sentences`/`videos`/`decks`/`stats`/`activity`) is owned
by the mobile app; the dashboard reads it and may set `users/{uid}.disabled = true`.

Security is enforced by `polyglot/firestore.rules` (an `isAdmin()` helper based on the `admins`
collection). Deploy it from the mobile project: `firebase deploy --only firestore:rules`.

## Setup

```bash
flutter pub get
dart run slang        # regenerate translations after editing lib/core/l10n/*.i18n.yaml
flutter run -d chrome
```

### Grant yourself admin access (one-time)

The dashboard only lets in users listed in the `admins` collection. After signing up / having an
account in the Parlo project:

1. Find your Firebase Auth **UID** (Firebase console → Authentication).
2. In Firestore, create a document `admins/<your-uid>` with `{ email: "<you>", addedAt: <timestamp> }`.
3. Sign in to the dashboard with that account.

## Notes / limitations

- **Delete user** removes the user's entire Firestore data tree but **not** their Firebase Auth
  login account — deleting an Auth account requires the Admin SDK (a Cloud Function), which is out
  of scope here. Use **disable** for a reversible ban; the mobile app signs disabled users out.
- Primary target is **web** (Chrome). A macOS desktop target is included but secondary.
