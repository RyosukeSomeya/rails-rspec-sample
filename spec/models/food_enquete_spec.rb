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

  # アンケート回答時の条件
  describe 'アンケート回答時の条件' do
    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do
        # テストデータ
        enquete_yamada = FoodEnquete.new(
          name: '山田花子',
          mail: 'hanako.yamada@example.com',
          age: 19,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1 # ビール飲み放題
        )
        # バリデーションでエラーが発生していること
        expect(enquete_yamada).not_to be_valid
        # エラー内容を検証
        expect(enquete_yamada.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できること' do
        # テストデータ
        enquete_yamada = FoodEnquete.new(
          name: '山田花子',
          mail: 'hanako.yamada@example.com',
          age: 20,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1 # ビール飲み放題
        )

        # バリデーションが発生していることを確認
        expect(enquete_yamada).to be_valid
      end
    end
  end

  # プライベートメソッドのテスト
  describe '#adult?' do
    it '20歳未満は成人でないこと' do
      food_enquete = FoodEnquete.new
      # sendでプライベートメッソっどを指定できる
      expect(food_enquete.send(:adult?, 19)).to be_falsey
    end

    it '20歳以上は成人である' do
      food_enquete = FoodEnquete.new
      expect(food_enquete.send(:adult?, 20)).to be_truthy
    end
  end
end
