require 'rails_helper'

RSpec.describe 'FoodEnquetes', type: :system do
  describe '正常' do
    context 'アンケートに回答する' do
      it '回答できること' do
        # テストデータ作成
        enquete = FactoryBot.create(:food_enquete_tanaka)
        # アンケートページアクセス
        visit '/food_enquetes/new'
        # テキストボックスに値を入力
        fill_in 'お名前', with: enquete.name
        fill_in 'メールアドレス', with: enquete.mail
        fill_in '年齢', with: enquete.age
        # セレクトボックス選択
        select enquete.food_name, from: 'お召し上がりになった料理'
        # ラジオボタン選択
        choose "food_enquete_score_#{enquete.score}"
        # テキストボックスに値を入力
        fill_in 'ご意見・ご要望', with: enquete.request
        # セレクトボックス選択
        select enquete.present_name, from: 'ご希望のプレゼント'

        click_button '登録する'

        # 回答完了の検証
        expect(page).to have_content 'ご回答ありがとうございました'
        expect(page).to have_content 'お名前: 田中 太郎'
        expect(page).to have_content 'メールアドレス: taro.tanaka@example.com'
        expect(page).to have_content '年齢: 25'
        expect(page).to have_content 'お召し上がりになった料理: やきそば'
        expect(page).to have_content '満足度: 良い'
        expect(page).to have_content 'ご意見・ご要望: おいしかったです。'
        expect(page).to have_content 'ご希望のプレゼント: 【10名に当たる】ビール飲み放題'
      end
    end
  end

  describe '異常' do
    context '必須項目が未入力' do
      it 'エラーが表示され、回答できないこと' do
        # アンケートページアクセス
        visit '/food_enquetes/new'

        # フォームが未入力のまま登録
        click_button '登録する'

        # 回答完了の検証
        expect(page).not_to have_content 'ご回答ありがとうございました'
        # エラーメッセージの確認
        expect(page).to have_content 'お名前を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content '年齢を入力してください'
        expect(page).to have_content '満足度を入力してください'
      end
    end
  end
end
