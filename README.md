# Lookbook Theme

A [Dawn](https://github.com/Shopify/dawn)-based Shopify theme implementing a **Lookbook** feature — an editorial, metaobject-driven product showcase that can be placed on any page through the theme customizer **and** surfaces automatically on a product page when that product belongs to a Lookbook.

Built entirely with **native Shopify features** (metaobjects + Liquid) — no third-party apps.

- **Store:** `lookbook-challenge.myshopify.com`
- **Development theme ID:** `141439402087`

## Deliverables at a glance

| Requirement | Where it lives |
| --- | --- |
| Lookbook **metaobject** schema (title, description, products, …) | Shopify admin → Content → Metaobjects → *Lookbook* (see [Metaobject schema](#metaobject-schema)) |
| Lookbook **theme section**, addable to any page, configurable in the customizer | [`sections/lookbook.liquid`](sections/lookbook.liquid) |
| Lookbook on **product pages** when the product is in a Lookbook | [`sections/product-lookbooks.liquid`](sections/product-lookbooks.liquid), wired into [`templates/product.json`](templates/product.json) |
| Shared styling (self-contained design system) | [`assets/lookbook.css`](assets/lookbook.css) |
| Customizer labels / strings | [`locales/en.default.schema.json`](locales/en.default.schema.json) |

## Metaobject schema

The feature is backed by a single **`lookbook`** metaobject definition. Create it in **Admin → Content → Metaobjects → Add definition** with these fields:

| Field (key) | Type | Purpose |
| --- | --- | --- |
| `title` | Single line text | Hero / lookbook title |
| `description` | Rich text | Editorial copy shown in the hero |
| `hero_image` | File (image) | Full-bleed hero background (optional — hero is omitted if empty) |
| `products` | List of product references | The products featured in the lookbook |

Storefront access must be enabled on the definition so Liquid can read it. Entries are managed like any other metaobject in the admin, and each entry can be **Active** or **Draft** (drafts stay hidden on the live storefront — see [Draft handling](#draft-handling)).

## How the two sections work

Both sections share the same markup and `assets/lookbook.css`, and both expose customizer text settings (section-bar label, eyebrow, "shop" label, card CTA, footer label) plus a `heading_level` select for accessible heading hierarchy.

### 1. Lookbook section — `sections/lookbook.liquid`

A merchant-placed section, enabled on `index`, `page`, `collection`, and `product` templates. Its main setting is a **metaobject picker** (`type: "metaobject"`, `metaobject_type: "lookbook"`) so the merchant chooses *which* Lookbook to display. It reads these fields off the selected entry:

| Field | Renders as |
| --- | --- |
| `title` | Hero title |
| `hero_image` | Full-bleed hero background (omitted if empty) |
| `description` | Hero description (rich text) |
| `products` | Product card grid + count bar |

### 2. Product Lookbooks section — `sections/product-lookbooks.liquid`

A **reverse lookup** added to the product template. It iterates the store's Lookbook metaobjects (`shop.metaobjects.lookbook.values`) and renders any Lookbook whose `products` list contains the current product — so a Lookbook appears on its members' product pages automatically, with no per-product configuration. It is enabled only on the `product` template and is already wired into [`templates/product.json`](templates/product.json).

## Implementation notes for maintainers

### Rich-text rendering
`description` is a rich-text field — output it with `{{ lookbook.description | metafield_tag }}`, **not** `{{ lookbook.description.value }}`. The `.value` form returns the raw AST and renders as a `{"type"=>"root"...}` hash on the page.

### Draft handling
A metaobject exposes **no** draft/active status in Liquid (there is no `published_at` accessor — only `.system` plus the defined fields). On the live storefront, Shopify suppresses a Draft entry's field values, so the sections detect draft by a **blank `title.value`** and skip rendering it. In `request.design_mode` (the theme editor) all field values are readable regardless of status, so drafts can't be distinguished there — the sections render the entry to keep it previewable and show a small note reminding the merchant that drafts stay hidden live.

### Reverse-lookup ceiling (product page)
`product-lookbooks.liquid` scans `shop.metaobjects.lookbook.values` with `limit: 250`. Lookbooks beyond position 250 are silently undetected — fine for the expected catalog size, but the client should be notified if the number of active Lookbooks approaches this ceiling.

### Card height (desktop)
Product card images use a fixed `height: 360px` at ≥990px rather than `aspect-ratio`, which otherwise stretches cards to full-column height.

## Local development

Run a dev server that live-syncs local files and reconciles editor content from the remote:

```bash
shopify theme dev --store lookbook-challenge --theme 141439402087
```

Saving a file updates the preview at `http://127.0.0.1:9292` instantly — no manual push needed.

## Uploading changes

> ⚠️ A plain `shopify theme push` overwrites the JSON files that hold **page/editor content**
> (`config/settings_data.json`, `templates/**/*.json`, `sections/*-group.json`), reverting
> any content set in the theme editor. Use the helper below to avoid this.

To upload **code** without clobbering content:

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

## Submission checklist

- [x] **Repository** with the theme code — this repo
- [x] **Store URL** where the Lookbooks can be viewed — `lookbook-challenge.myshopify.com`
- [x] **Metaobject configuration** — screenshots of the `lookbook` definition / admin access (provided alongside this submission)

---

## About Dawn

This theme is built on Shopify's [Dawn](https://github.com/Shopify/dawn) reference theme (HTML-first, Online Store 2.0). Useful upstream references:

- [Shopify CLI for themes](https://shopify.dev/docs/themes/tools/cli)
- [Theme Check](https://github.com/Shopify/theme-check)
- [Shopify Metaobjects](https://shopify.dev/docs/apps/build/custom-data/metaobjects)

### Staying up to date with Dawn

```sh
git remote add upstream https://github.com/Shopify/dawn.git
git fetch upstream
git pull upstream main
```

## License

Copyright (c) 2021-present Shopify Inc. See [LICENSE](/LICENSE.md) for details.
