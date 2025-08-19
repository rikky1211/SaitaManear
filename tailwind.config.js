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

  safelist: [
    "btn",
    { pattern: /btn-(?:neutral|primary|secondary|accent|info|success|warning|error)/ },
    { pattern: /bg-(?:red|blue|green|yellow|pink|lime)-(?:[1-9]00)/ },
    { pattern: /(?:p|m)(?:x|y)?-(?:[1-9]|1[1-9]|20)/},
    { pattern: /[wh]-(?:[0-9]|[1-9][0-9]|[1-9][0-9]?)/ },
  ],
}