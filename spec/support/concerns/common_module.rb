require 'rails_helper'

shared_examples '入力項目の有無' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  context '必須入力であること' do
    it 'お名前が必須入力であること' do
      # バリデーションエラーの検証
      expect(model).not_to be_valid
      # お名前に関するエラーの配列を取り出して検証
      expect(model.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end

    it 'メールアドレスが必須であること' do
      expect(model).not_to be_valid
      # メールアドレスに関するエラーの配列を取り出して検証
      expect(model.errors[:mail]).to include(I18n.t('errors.messages.blank'))
    end

    it '登録できないこと' do
      # 必須項目が未入力なので登録できない
      expect(model.save).to be_falsey
    end
  end

  # 任意入力のテスト
  context '任意入力であること' do
    it 'ご意見・ご要望が任意であること' do
      expect(model).not_to be_valid
      # ご意見ご要望に関するエラーの配列を取り出して、必須入力のエラーが含まれないことを検証
      expect(model.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
    end
  end
end

shared_examples 'メールアドレスの形式' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  context '不正なメールアドレスの場合' do
    it 'エラーになること' do
      new_enquete = FoodEnquete.new
      # 不正な形式のメールアドレス
      new_enquete.mail = 'taro.tanaka'
      expect(new_enquete).not_to be_valid
      # メールアドレスの形式が不正であるエラーの確認
      expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.invalid'))
    end
  end
end

# 各モデルから共通で呼ばれるテストケース
shared_examples '価格の表示' do
  # 呼び出し元のモデルを動的に定義（複数のモデルが呼び出すので）
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  # 8%で計算
  describe '税込価格が計算されること' do
    it '8%加算されること' do
      expect(model.tax_included_price(100)).to eq 108
    end

    it '8%加算され、小数点以下は切り捨てられること' do
      expect(model.tax_included_price(101)).to eq 109
    end
  end
end

shared_examples '満足度の表示' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  it '満足度が「悪い」になること' do
    model.score = 1
    expect(model.view_score).to eq I18n.t('common.score.bad')
  end

  it '満足度が「普通」になること' do
    model.score = 2
    expect(model.view_score).to eq I18n.t('common.score.normal')
  end

  it '満足度が「良い」になること' do
    model.score = 3
    expect(model.view_score).to eq I18n.t('common.score.good')
  end

  it '満足度が「不明」になること' do
    model.score = 0
    expect(model.view_score).to eq I18n.t('common.score.unknown')

    model.score = 4
    expect(model.view_score).to eq I18n.t('common.score.unknown')
  end
end
