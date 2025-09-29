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
    // btn
    "btn",
    "btn-error",
    "btn-primary",
    "btn-secondary",
    "btn-warning",
    "btn-info",
    "btn-success",
    "btn-accent",

    "btn-circle",

    // [p|m][x|y]
    "w-2",
    "w-3",
    "w-4",
    "w-8",
    "w-16",
    "w-32",
    
    "h-2",
    "h-3",
    "h-4",
    "h-8",
    "h-16",
    "h-32",

    "ml-2",
    "ml-4",

    "pb-4",
    "pb-6",
    "pb-8",

    { pattern: /(hover:)?bg-(?:red|blue|green|yellow|pink|lime)-(?:[1-9]00|50)/ },
    { pattern: /(?:p|m)(?:x|y)?-(?:[1-9]|1[1-9]|20)/},
    { pattern: /[wh]-(?:[0-9]|[1-9][0-9]|[1-9][0-9]?)/ },
  ],
}