import { defineConfig } from "vite";
import { resolve } from "path";
import { fileURLToPath } from "url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));

export default defineConfig({
  server: {
    watch: {
      usePolling: true,
    },
  },
  build: {
    rollupOptions: {
      input: {
        cv: resolve(__dirname, "sites/cv/index.html"),
        onepager: resolve(__dirname, "sites/onepager/index.html"),
        start: resolve(__dirname, "sites/start/index.html"),
        navbar: resolve(__dirname, "sites/navbar/index.html"),
        mdsite: resolve(__dirname, "sites/mdsite/index.html"),
        data: resolve(__dirname, "sites/data/index.html"),
        wallpapers: resolve(__dirname, "sites/wallpapers/index.html"),
      },
    },
  },
});