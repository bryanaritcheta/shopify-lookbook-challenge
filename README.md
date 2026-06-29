# Lookbook Theme

A [Dawn](https://github.com/Shopify/dawn)-based Shopify theme with a custom **Lookbook** section — an editorial, metaobject-driven product showcase.

- **Store:** `lookbook-challenge.myshopify.com`
- **Development theme ID:** `141439402087`

## The Lookbook section

[`sections/lookbook.liquid`](sections/lookbook.liquid) renders an editorial "Lookbook" backed by a `lookbook` **metaobject**. Styling lives in [`assets/lookbook.css`](assets/lookbook.css) (a self-contained design system, all rules scoped to `.lookbook`).

### How it works

The section has one main setting — a metaobject picker (`lookbook`) — plus a `heading_level` select. It reads these fields off the selected metaobject entry:

| Field | Type | Renders as |
| --- | --- | --- |
| `title` | text | Hero title (`FIRST TRACKS`) |
| `hero_image` | image | Full-bleed hero background (hero is omitted if empty) |
| `description` | rich text | Hero description |
| `products` | product list | Product card grid + count bar |
| `published_at` | (system) | Draft guard — see below |

### Notes for maintainers

- **Rich-text rendering:** `description` is a rich-text field. Output it with `{{ lookbook.description | metafield_tag }}`, **not** `{{ lookbook.description.value }}` — the `.value` form returns the raw AST and renders as a `{"type"=>"root"...}` hash on the page.
- **Draft guard:** a metaobject entry set to *Draft* still passes the picker's truthy check, but Shopify suppresses its field values on the live storefront. The section checks `published_at == blank` and, in the theme editor only, shows a warning instead of an empty shell.
- **Card height (desktop):** product card images use a fixed `height: 360px` at ≥990px rather than `aspect-ratio`, which otherwise blows the cards up to full-column height.

## Local development

Run a dev server that live-syncs your local files and reconciles editor content from the remote (recommended while iterating):

```bash
shopify theme dev --store lookbook-challenge --theme 141439402087
```

Saving a file updates the preview at `http://127.0.0.1:9292` instantly — no manual push needed.

## Uploading changes

> ⚠️ A plain `shopify theme push` overwrites the JSON files that hold **page/editor content**
> (`config/settings_data.json`, `templates/**/*.json`, `sections/*-group.json`), reverting
> any content set in the theme editor. Use the helper below to avoid this.

To upload **code** without clobbering content, run:

```bash
./push.sh
```

[`push.sh`](push.sh) pushes everything except the content JSON files. To push a single file directly (always content-safe for `.liquid`/`assets`):

```bash
shopify theme push --theme 141439402087 --only "sections/lookbook.liquid"
```

**Mental model:** `.liquid` + `assets/` + `config/settings_schema.json` = *code* (safe to push). `templates/**/*.json` + `config/settings_data.json` + `sections/*-group.json` = *content* (pushing these reverts editor work).

## Linting

```bash
shopify theme check
```

---

## About Dawn

This theme is built on Shopify's [Dawn](https://github.com/Shopify/dawn) reference theme (HTML-first, Online Store 2.0). Useful upstream references:

- [Shopify CLI for themes](https://shopify.dev/docs/themes/tools/cli)
- [Theme Check](https://github.com/Shopify/theme-check)
- [Dawn contribution guide](https://github.com/Shopify/dawn/blob/main/.github/CONTRIBUTING.md)

### Staying up to date with Dawn

```sh
git remote add upstream https://github.com/Shopify/dawn.git
git fetch upstream
git pull upstream main
```

## License

Copyright (c) 2021-present Shopify Inc. See [LICENSE](/LICENSE.md) for details.
