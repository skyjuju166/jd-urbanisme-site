# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Static website for **JD Urbanisme** — Julien Dallemagne, an urban-planning law consultant (urbanisme: PLU, ZAN, jurisprudence) operating in Auvergne-Rhône-Alpes, France. The live site is `https://juliendallemagne.fr`. All content is in **French** (`lang="fr"`).

There is **no build system, no package manager, no tests, and no linter**. Every page is hand-written, self-contained HTML with inline CSS and inline JS. To preview a page, open the `.html` file in a browser (e.g. `python3 -m http.server` from inside `site/`).

This repo manages **only the "Actualités" (news/blog) section** of the site. The homepage and other pages (`index`, `equipe.html`, `img/`, `og-image.svg`, the logo, etc.) live on the production server and are **not** in this repo — they are referenced by absolute URL but won't be found locally. Many article cards in `actualites.html` link to articles that are not yet present in `site/`; this is expected (they are published over time).

## Repository layout

- `site/` — the **only** deployable directory. Contains the article pages, the news index, and the sitemap. Everything here is mirrored to the server.
  - `actualites.html` — the Actualités index/listing page (article-card grid).
  - `actualite-<slug>-<year>.html` — one self-contained file per news article.
  - `sitemap.xml` — must be updated by hand when articles are added.
- `.github/workflows/deploy.yml` — FTP deployment to the o2switch host.

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which:
1. Re-downloads the contents of `site/` via the GitHub Contents API (not the checked-out tree).
2. Mirrors them over FTP to `/public_html/` on `ftp.wujo2132.odns.fr` using `lftp` and the `FTP_PASSWORD` secret.

The mirror uses `mirror -R` **without `--delete`**, so deployment only adds/overwrites files — it never removes files from the server. Renaming or deleting a page in the repo will not remove the old one in production.

Develop on a feature branch; merging/pushing to `main` is what publishes. Do not push directly to `main` unless explicitly asked.

## Page anatomy (the convention every article follows)

Each article file is **fully self-contained** — the entire design system, navigation, footer, and scripts are duplicated inline in every file rather than shared. When creating or editing an article, copy an existing recent article (e.g. `actualite-cerfa-16702-16703-janvier-2026.html`) as the template and change the content; do not try to extract shared assets.

A page contains, in order:
1. **SEO `<head>`**: `<title>`, `meta description`, `meta keywords`, `link rel=canonical`, OpenGraph (`og:*`, `og:type=article`), Twitter card, `meta author` = "Julien Dallemagne", and `article:published_time`.
2. **JSON-LD blocks** (`<script type="application/ld+json">`): articles carry `Article` + `FAQPage` + `BreadcrumbList`; `actualites.html` carries `CollectionPage` + `ItemList` of `NewsArticle`. Keep these in sync with the visible content.
3. **Inline `<style>`** — the shared "charte graphique" (see below). Identical across files.
4. **Fixed `<nav>`** + mobile burger menu (`#mobile-menu`, `#nav-burger`).
5. **Article body**: `.breadcrumb`, `.article-hero.topo-hero`, `.article-layout` (`.article-body` + `.article-sidebar` with `.sidebar-box`), `.callout` / `.callout-warning`, and a `.faq` accordion (`.faq-item` → `.faq-question` / `.faq-answer`).
6. **`.refs-cta`** call-to-action band and **`<footer class="topo-dark">`**.
7. **Inline `<script>`**: nav shadow-on-scroll, FAQ accordion toggle (single-open), and mobile burger menu.

## Design system (charte graphique)

Defined via CSS custom properties in `:root` — reuse these tokens, do not hardcode colors:

- Brand teal: `--teal:#4B9B9C`, `--teal-dark:#3a8081`, `--teal-light:#e8f4f4`
- Text/surfaces: `--ink:#1A1F2E`, `--slate:#4A5568`, `--paper:#F4F1EC`, `--cream:#F8F2DD`, `--white`
- Fonts: `--font-body` = "Source Sans 3" (loaded from Google Fonts); `--font-mono` = Menlo/Monaco/Consolas (used for headings, tags, dates, meta)
- Radii `--r:6px` / `--r-lg:12px`; shadows `--shadow-sm` / `--shadow-md`
- Decorative topographic-contour SVG backgrounds are embedded as data-URIs in `.topo-hero` (light) and `.topo-dark` (dark footer/CTA).

## Conventions when adding a weekly article

1. Create `site/actualite-<descriptive-slug>-<year>.html` from a recent article template.
2. Update **all** SEO/meta/JSON-LD to match the new content (title, description, canonical URL, breadcrumb name, FAQ Q&A, dates).
3. Add a card linking to the new article in `site/actualites.html`, and add it to that page's `CollectionPage`/`ItemList` JSON-LD.
4. Add a `<url>` entry in `site/sitemap.xml` with an appropriate `lastmod` date.
5. Commit message style (existing history): `Article hebdo: <filename>` for new articles, `fix: <description>` for corrections.

## Fixed reference values (keep consistent across pages)

- Email: `urbanisme@juliendallemagne.fr` · Phone: `+33422915063` · SIRET: `852 630 953 00028`
- Author / Person URL: `https://juliendallemagne.fr/equipe.html`
- Publisher: "JD Urbanisme", logo `https://juliendallemagne.fr/img/logo-jd-urbanisme.png`
