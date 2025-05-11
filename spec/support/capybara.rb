# spec/support/capybara.rb
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :chrome_headless_with_gpu do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # ヘッドレスモード
  options.add_argument('--headless=new')      # Chrome 109+ の新しいヘッドレス
  # GPU 周りの設定
  options.add_argument('--disable-gpu')        # GPU 無効化フラグ
  options.add_argument('--disable-software-rasterizer') 
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  # ウィンドウサイズを指定（スクリーンショットの解像度に直結します）
  options.add_argument('--window-size=1920,1080')

  # Xvfb 上で動く場合に間接レンダリングを有効化
  ENV['LIBGL_ALWAYS_INDIRECT'] = '1'

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# JavaScript テストではこのドライバを使う
Capybara.javascript_driver = :chrome_headless_with_gpu

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :chrome_headless_with_gpu
  end
end
