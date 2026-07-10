# Blog

This is a personal blog built with [Astro](https://astro.build) and hosted on
GitHub Pages at [blog.msmoiz.com](https://blog.msmoiz.com).

## Writing a post

To add a post, add a Markdown file to `src/content/blog/` with frontmatter:

```md
---
title: Post title
description: Optional short description
pubDate: 2026-07-09
---

Post content here.
```

## Development

To start the development server, run the following commands:

```sh
npm install
npm run dev
```

## Deployment

When you push to `main`, it triggers a GitHub workflow that builds the site and
publishes it to GitHub Pages. You can configure the routing settings through the
settings page for this repo.
