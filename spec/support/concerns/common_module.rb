require 'rails_helper'

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
