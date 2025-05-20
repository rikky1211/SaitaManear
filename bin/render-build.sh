set -o errexit

bundle install
yarn install
yarn build                # JSをビルド（esbuild）
yarn build:css            # ←★ Tailwind CSSをビルド（これがなかった）

bundle exec rails assets:precompile
bundle exec rails db:migrate