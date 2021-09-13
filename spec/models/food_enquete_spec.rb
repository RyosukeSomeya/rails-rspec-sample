require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:やきそば food_id: 2,
      満足度:良い score: 3,
      希望するプレゼント:ビール飲み放題 present_id: 1)' do
        # Test Data (FactoryBotから作成)
        enquete = FactoryBot.build(:food_enquete_tanaka) # buildでデータを生成(saveはしない)

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

  # アンケート回答時の条件
  describe 'アンケート回答時の条件' do
    context 'メールアドレスを確認すること' do
      # 一人目のデータは以降の2つのテストケースで共通なので事前処理する
      before do
        FactoryBot.create(:food_enquete_tanaka) # create => saveもする
      end

      it '同じメールアドレスで再び回答できないこと' do
        # 二人目のデータ(メールアドレスが同じ) 第2引数でデータ内容の上書き
        re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: 'スープがぬるかった')

        # バリデーションエラーが発生する
        expect(re_enquete_tanaka).not_to be_valid

        # メールアドレスがすでに存在するエラーメッセージの確認
        expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
        # 2つ目のアンケートは保存できない
        expect(re_enquete_tanaka.save).to be_falsey
        # アンケート数は最初のものだけなので一つのはず
        expect(FoodEnquete.all.size).to eq 1
      end

      it '異なるメールアドレスで再び回答でること' do
        # 二人目のデータ(メールアドレスが異なる)
        enquete_yamada = FactoryBot.build(:food_enquete_yamada)

        expect(enquete_yamada).to be_valid
        enquete_yamada.save
        # アンケートは2つdbに保存されている
        expect(FoodEnquete.all.size).to eq 2
      end
    end

    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do
        # テストデータ
        enquete_sato = FactoryBot.build(:food_enquete_sato)
        # バリデーションでエラーが発生していること
        expect(enquete_sato).not_to be_valid
        # エラー内容を検証
        expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できること' do
        # テストデータ
        enquete_sato = FactoryBot.build(:food_enquete_sato, age: 20)

        # バリデーションが発生していることを確認
        expect(enquete_sato).to be_valid
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

  # 共通バリデーション
  describe '共通バリデーション' do
    it_behaves_like '入力項目の有無'
    it_behaves_like 'メールアドレスの形式'
  end

  # 共通メソッドのテスト
  describe '共通メソッド' do
    # support/concerns/common_module.rbで定義したテストケースの呼び出し
    it_behaves_like '価格の表示'
    it_behaves_like '満足度の表示'
  end
end
