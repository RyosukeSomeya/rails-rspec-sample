require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  describe "正常" do
    context 'アンケートに回答する' do
      it '回答できること' do
        # アンケートページへアクセス
        get '/food_enquetes/new'
        expect(response).to have_http_status(200)

        # 正常な値を入力し送信する
        post '/food_enquetes', params: { food_enquete: FactoryBot.attributes_for(:food_enquete_tanaka) }

        # リダイレクト先に移動
        follow_redirect!

        # 送信完了のメッセージがレスポンスに含まれることを検証します。
        expect(response.body).to include 'お食事に関するアンケートを送信しました'
      end
    end
  end

  describe "異常" do
    context 'アンケートに回答する' do
      it 'エラーメッセージが表示されること' do
        # アンケートページへアクセス
        get '/food_enquetes/new'
        expect(response).to have_http_status(200)

        # 異常値を入力し送信する
        post '/food_enquetes', params: { food_enquete: { name: '' } }

        # 送信完了のメッセージがレスポンスに含まれないことを検証します。
        expect(response.body).not_to include 'お食事に関するアンケートを送信しました'
      end
    end
  end


end
