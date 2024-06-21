# Task 4 Details

This task will be a CI/CD pipeline for a [SvelteKit](https://kit.svelte.dev/) project (Full stack JS framework, similar to Next JS) using GitHub actions.

A new SvelteKit demo app has been scaffolded using the commands:

```bash
pnpm create svelte@latest my-app
cd my-app
pnpm install
pnpm run dev
```

`/my-app/github/workflows/ci-cd.yml` contains the config file for building, testing, and deployment. 

By default SvelteKit uses SSR (server-side rendering) to render pages, so a server is required for the deployment step. For time sake, I've left this part out but it can be configured with your own server or a hosting service like Render or Fly.io.
