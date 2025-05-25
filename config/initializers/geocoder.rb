Geocoder.configure(
  # 例: タイムアウト時間
  timeout: 5,
  # 例: 使用するAPIや言語
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],
  units: :km,
  language: :ja,
)