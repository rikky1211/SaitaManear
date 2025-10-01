FactoryBot.define do
  factory :spot do
    name { Faker::Lorem.words(number: 2).join(' ') }
    # より厳密な埼玉県内の緯度経度範囲に修正
    latitude { rand(35.85..36.15) }   # 埼玉県の確実な範囲
    longitude { rand(139.15..139.75) } # 埼玉県の確実な範囲
    association :user
    
    # Active Storageの画像ファイルを添付
    after(:build) do |spot|
      spot.spot_image.attach(
        io: StringIO.new("fake image data"),
        filename: 'test_image.jpg',
        content_type: 'image/jpeg'
      )
    end

    # 埼玉県の主要都市別のtrait（確実に通る座標）
    trait :saitama_city do
      latitude { 35.8617 }   # さいたま市役所の座標
      longitude { 139.6455 }
    end

    trait :kawagoe do
      latitude { 35.9249 }   # 川越市役所の座標
      longitude { 139.4851 }
    end

    trait :omiya do
      latitude { 35.9058 }   # 大宮駅の座標
      longitude { 139.6231 }
    end

    trait :urawa do
      latitude { 35.8617 }   # 浦和駅の座標
      longitude { 139.6455 }
    end

    trait :without_image do
      after(:build) do |spot|
        # 画像を添付しない
      end
    end
  end
end