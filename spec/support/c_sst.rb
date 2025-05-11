# spec/support/capybara_screenshot.rb
require 'capybara-screenshot/rspec'

# テスト失敗時に自動でスクリーンショットを撮るのを無効化（手動で撮りたい場合）
Capybara::Screenshot.autosave_on_failure = true

# スクリーンショットの保存先ディレクトリ（デフォルトは tmp/capybara）
Capybara.save_path = Rails.root.join('tmp', 'capybara')