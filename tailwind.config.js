module.exports = {
  content: [
    './app/views/**/*.html.erb',  // これでビューのHTMLファイルを監視します
    './app/helpers/**/*.rb',      // ヘルパーファイルも監視対象に
    './app/javascript/**/*.js',   // JavaScriptファイルも監視対象に
    './app/assets/stylesheets/*.css'
  ],

  plugins: [require("daisyui")],
  daisyui: {
  },

  // Tailwind v4以降は正規表現不可らしい。
  safelist: [
    "btn",
    "btn-error",
    "btn-primary",
    "btn-secondary",
    "btn-warning",
    "btn-info",
    "btn-success",
    "btn-accent",
    { pattern: /(hover:)?bg-(?:red|blue|green|yellow|pink|lime)-(?:[1-9]00|50)/ },
    { pattern: /(?:p|m)(?:x|y)?-(?:[1-9]|1[1-9]|20)/},
    { pattern: /[wh]-(?:[0-9]|[1-9][0-9]|[1-9][0-9]?)/ },
  ],
}