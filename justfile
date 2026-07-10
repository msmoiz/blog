# Lists available recipes
default:
    @just --list

# Starts the development server
dev:
    npx astro dev

# Builds the static site
build:
    npx astro build

# Starts a preview server
preview:
    npx astro preview
