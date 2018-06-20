import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import buble from "rollup-plugin-buble";
import pkg from "./package.json";

export default [
  // browser-friendly UMD build
  {
    input: "src/js/main.js",
    output: {
      file: pkg.browser,
      format: "umd",
      name: "elmMapbox"
    },
    plugins: [
      resolve(), // so Rollup can find `ms`
      commonjs(), // so Rollup can convert `ms` to an ES module
      // buble({
      //   // transpile ES2015+ to ES5
      //   exclude: ["node_modules/**"]
      // })
    ]
  },

  // CommonJS (for Node) and ES module (for bundlers) build.
  // (We could have three entries in the configuration array
  // instead of two, but it's quicker to generate multiple
  // builds from a single configuration where possible, using
  // the `targets` option which can specify `dest` and `format`)
  {
    input: "src/js/main.js",
    external: ["mapbox-gl"],
    output: [
      { file: pkg.main, format: "cjs" },
      { file: pkg.module, format: "es" }
    ],
    plugins: [
      // buble({
      //   exclude: ["node_modules/**"]
      // })
    ]
  }
];
