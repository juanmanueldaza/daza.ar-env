import { defineConfig } from 'vite';
import { resolve } from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

// Load site config from sites.config.json
const sites = JSON.parse(fs.readFileSync(resolve(__dirname, 'sites.config.json'), 'utf-8'));

const input = {};
for (const site of sites) {
  input[site.name] = resolve(__dirname, site.entry);
}

export default defineConfig({
  server: {
    watch: {
      usePolling: true,
      // Watch markdown, json, and static files for hot reload
      ignored: [
        '!**/*.md',
        '!**/*.json',
        '!**/*.yml',
        '!**/*.yaml',
        '!**/*.csv',
        '!**/*.xml',
        '!**/*.txt',
        '!**/public/**',
      ],
    },
  },
  build: {
    rollupOptions: {
      input,
    },
  },
});
