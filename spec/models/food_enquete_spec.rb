require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:やきそば food_id: 2,
      満足度:良い score: 3,
      希望するプレゼント:ビール飲み放題 present_id: 1)' do
        # Test data
        enquete = FoodEnquete.new(
          name: '田中 太郎',
          mail: 'taro.tanaka@example.com',
          age: 25,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )

        # バリデーション検証
        expect(enquete).to be_valid

        # データ保存
        enquete.save

        # データ取得
        answered_enquete = FoodEnquete.find(1)

        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)
      end
    end
  end

  # 必須項目のテスト
  describe '入力項目の有無'do
    context '必須入力であること' do
      it 'お名前が必須入力であること' do
        new_enquete = FoodEnquete.new
        # バリデーションエラーの検証
        expect(new_enquete).not_to be_valid
        # お名前に関するエラーの配列を取り出して検証
        expect(new_enquete.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end

      it 'メールアドレスが必須であること' do
        new_enquete = FoodEnquete.new
        expect(new_enquete).not_to be_valid
        # メールアドレスに関するエラーの配列を取り出して検証
        expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.blank'))
      end

      it '登録できないこと' do
        # 必須項目が未入力なので登録できない
        new_enquete = FoodEnquete.new
        expect(new_enquete.save).to be_falsey
      end
    end
  end

  # 任意入力のテスト
  describe '任意入力であること' do
    it 'ご意見・ご要望が任意であること' do
      new_enquete = FoodEnquete.new
      expect(new_enquete).not_to be_valid
      # ご意見ご要望に関するエラーの配列を取り出して、必須入力のエラーが含まれないことを検証
      expect(new_enquete.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
    end
  end
end
