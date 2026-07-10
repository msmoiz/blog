# Blog

Personal blog built with [Astro](https://astro.build), hosted on GitHub Pages
at [blog.msmoiz.com](https://blog.msmoiz.com).

## Writing a post

Add a Markdown file to `src/content/blog/` with frontmatter:

```md
---
title: Post title
description: Optional short description
pubDate: 2026-07-09
---

Post content here.
```

## Development

```sh
npm install
npm run dev
```

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds the
site and publishes it to GitHub Pages. In the repo settings, set
**Pages > Source** to **GitHub Actions**. The `public/CNAME` file points the
custom domain at `blog.msmoiz.com`; DNS is managed separately.
