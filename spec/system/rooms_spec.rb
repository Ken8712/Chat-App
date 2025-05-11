require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
    @user = @room_user.user
    @room = @room_user.room
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      # サインインする
      sign_in(@user)

      # 作成されたチャットルームへ遷移する
      click_on(@room.name)

      # DBに保存されていないことを確認する 
      expect{
        find("input[name='commit']").click
      }.not_to change{Message.count}

      # 元のページに戻ってくることを確認する
      expect(page).to have_current_path(room_messages_path(@room))
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
      post = "テスト"
      find("input[class='form-message']").fill_in(with: post)

      # 送信した値がDBに保存されていることを確認する
      expect{
        find("input[name='commit']").click
        sleep 1
      }.to change{Message.count}.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(page).to have_current_path(room_messages_path(@room))
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file("message[image]", image_path, make_visible: true)

      # 送信した値がDBに保存されていることを確認する
        expect{
        find("input[name='commit']").click
        sleep 1
      }.to change{Message.count}.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(page).to have_current_path(room_messages_path(@room))

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end

    it 'テキストと画像の投稿に成功する' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file("message[image]", image_path, make_visible: true)

      # 値をテキストフォームに入力する
      post = "テスト"
      find("input[class='form-message']").fill_in(with: post)


      # 送信した値がDBに保存されていることを確認する
      expect{
        find("input[name='commit']").click
        sleep 1
      }.to change{Message.count}.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)


      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
      

    end
  end



end

RSpec.describe 'チャットルームの削除機能', type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
    @user = @room_user.user
    @room = @room_user.room

  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されている' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # メッセージ情報を5つDBに追加する
    FactoryBot.create_list(:message, 5, content: "hello", user_id: @user.id, room_id: @room.id )

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
    binding.pry
    expect{
      click_on("チャットを終了する")
      sleep 1
    }.to change{Message.count}.by(-5)
    binding.pry
    # トップページに遷移していることを確認する
    expect(page).to have_current_path(root_path)

  end
end
