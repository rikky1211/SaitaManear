# ■サービス名：SaitaManear
## ※Saitama + Mania + near

## ■サービス概要
- 埼玉県の有名な観光地などに向かった「ついでに」サイトにはあまり書かれていない
  現在地から近くの知られていない秘境や、なんや変わりのなさそうな場所の魅力を検索して探索ができる。

- 特に変わり映えのないけど見てみたら面白い階段や、身近にある人目に触れないな変な物などまで、有名な場所以外にも巡る場所を増やすためのサービス。


## ■開発背景
  地方でよくやりたいことや食べたいものなど、サイトをみて体験しに行く事は誰でもあると思います。

  各観光地に向かうためには数時間かける必要があり、
  わざわざ朝早くから起きて遊びに来ているのに、目的地に行く時間だけで相当な時間をかけてしまいます。

  また、その観光地に何度も行った場合も、行き帰りで数時間かける必要が出てきたり、
  何度も行っていると面白みがなくなってしまいます。

  別の観光地に向かう途中や、帰り途中で軽く寄れて面白いと思えるような場所を少し寄る場所を増やすだけで
  日帰り旅行から長期の旅行で面白いかなと思い制作を決めました。

  ※ 埼玉に絞ろうとした理由
  - 自身が埼玉育ちで、現在も埼玉在住。地元の良い所を知ってもら痛いと思ったため。
  - 気軽に登録された場所に迎えて、ユーザも自身も楽しめるようにしたいと思ったため。
  - 細かい所の魅力が伝われば地方に行った時についでに行こうと思う場所が増え、埼玉県各地の売り上げに貢献できるのでは…？

## ■ユーザー/ターゲット層について
- 埼玉県民
- 旅行をよくする人
- 写真をよく撮りにいく人
- 道の駅などの地方の店や、各地域の観光しにいく人


## ■サービスの利用イメージ
### 全ユーザ
- ユーザや各地地元民が投稿した埼玉県各地域での見所を見ることができる。
- 地域、旬、公共物、公共施設などの検索ができる。
- 現在位置や地図検索の場所から近くの探索場所がマップに表示される。
- そのタグをつけた場所の情報や公式アカウントのサービス内容など確認ができる。
- XやLINEによる場所の共有
  

### アカウント有りの場合（上記機能に併せて）
- お気に入り登録
- イイね！、行って見たい！、良かった！ボタン機能
- 地点登録（月数回の回数制限あり）
  

### adminアカウント（埼玉県の地元民やの場合
- 公式アカウントのサービス提供場所と概要登録
- 公式バッジをつける
- 地点登録
  

## ■ユーザーの獲得について
- Twitterでの宣伝 / 協力依頼
- 各地のお店やサービス提供している場所に連絡 / 協力依頼
- キャンプや観光などよくいく人に対して連絡 / 協力依頼
- 埼玉県民に協力依頼(RUNTEQ受講生にも呼びかけ)


## ■サービスの差別化ポイント
- [Instagram](https://www.instagram.com/?locale=ja_JP)
  - 若者向けの画像/動画投稿アプリケーション。綺麗な景色、秘境や色々な画像が投稿されている。
    ハッシュタグもたくさんついており、画像によっては住所の記載があり、調べて見に行くことも可能。
    →差別化内容
      ・その観光地に行く「ついでに」寄れるといったことが目的のアプリなので、また用途が異なる点
      ・全情報をGoogleMapに表示させ、検索せずともあたりの情報を出せる点
      ・埼玉県のみの情報に特化する点
      ・人はあまり映らず、余計な情報はあまり入れない点


- [埼玉県公式サイト(彩の国へようこそ 観光・魅力)](https://www.pref.saitama.lg.jp/theme/kankou/index.html)
  - よく知られている祭りや公園が登録されており、地域エリアごとやジャンルごとに振り分けされている。
    →差別化内容
      ・よく知られている場所を紹介しているので、その途中での細かい内容がない点が異なる。


## ■ 機能候補
### MVPリリース時に作っていたいもの
#### 全ユーザー
- ユーザ登録機能
- 周辺のリサーチ
  - Google Maps表示
    - Google Mapsの現在地取得
    - 現在地から数km圏内の場所を取得
    - 目的地の地区町村毎のエリア検索
- 登録地点概要表示

#### アカウント有りのユーザ
- ログイン/ログアウト機能機能
- お気に入り登録
- マイページ
  - 新規秘境/変な物発見登録
    - 登録名
    - 場所
    - 写真
    - 概要
  - プロフィール
  - お気に入り一覧
    - お気に入り検索
    - お気に入り削除

### 本リリースまでに作っていたいもの
#### 全ユーザー
- レスポンシブ対応
- Xにシェア
- 住所検索から数km圏内の場所を取得
- 「植物」、「施設」、「物」、「季節」などのタグ検索
- Google Plase API による近くの施設の実装
  - タグによる色分け
- 削除要請機能
- Googleアカウントによるログイン認証
- 【時間があれば】 LINEログイン認証
- 【時間があれば】 LINE共有

#### アカウント有りのユーザ
- イイね！、行って見たい！、行ってみた！ボタン機能
  （コメントはその場所の評価落とす内容など投稿される可能性があるため実装しない方針）

#### adminユーザアカウント
- ログイン/ログアウト機能機能
- 登録内容一覧
  - アカウント情報
  - 地点登録
    - Title
    - Body
    - タグ
    - 住所
  - 編集
  - 削除
  - 検索機能


## 懸念点と対策
  (1) ユーザが投稿できると以下問題が発生する。
    ※1.逆に情報が膨大になってしまい、ユーザにとっても情報過多となってしまう。
    ※2.人の土地なのに登録してしまう。
    対策：
      ・ユーザによる地点登録は登録回数は月5回までとする。
      ・削除要請機能を作成。

  (2) 登録できる情報がすぐに増えない。
    対策:
      ・アプリの形が取れ次第、
        PC/スマホを持ち、歩き回って登録したり、各地元の人に協力を仰ぐ


## ■予定している使用技術
###### ＞以下の情報から選定して使用
- フロントエンド
  - HTML
  - CSS(TailWind)
  - JavaScript

- バックエンド
  - Ruby 3.3.6
  - Ruby on Rails 7.2.2.1

- データベース
  - PostgreSQL

- 認証
  - Devise
  - Googleログイン認証

- API
  - Google Maps JavaScript API
    -> 必要事項：Google Mapを表示 -> キャッチアップ：表示成功

  - Google Geolocation API
    -> 必要事項：Google Mapで現在地を表示 -> キャッチアップ：表示成功

  - Google Geocoding API : 住所、緯度経度
    -> 必要事項：Google Mapで検索欄を表示・検索できること -> キャッチアップ：表示・検索成功

< 以下は時間があれば >
  - Google Places API :GoogleMapに登録されたものを取得可
    -> 知られている施設なども入れておくことで、その地域の売上につながるかも？ -> 本リリースにて考える。

  - LINE Messaging API（実装未定）
  - LINE Developers（実装未定）

- 環境構築
  - Docker

- Webアプリケーションサーバ
  - Fry.io 
    -> ひとまずキャッチアップでデプロイ完了。

- ファイルサーバ
  - Amazon S3
