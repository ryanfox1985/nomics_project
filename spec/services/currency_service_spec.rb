# frozen_string_literal: true

RSpec.describe CurrencyService do
  let(:parameters) { raise 'Define it!' }

  shared_examples 'multiple_currencies' do
    context 'multiple currencies' do
      let(:parameters) { { ids: %w[BTC ETH] } }

      it 'returns multiple metadata' do
        expect(subject.size).to eq(2)
      end
    end
  end

  describe '#metadata' do
    subject { described_class.metadata(parameters) }

    context 'single currency' do
      let(:parameters) { { ids: 'BTC' } }

      it 'returns one metadata' do
        expect(subject.size).to eq(1)
        expect(subject.first.keys).to eq(%w[id original_symbol name description website_url logo_url
                                            blog_url discord_url facebook_url github_url medium_url reddit_url telegram_url twitter_url whitepaper_url youtube_url linkedin_url bitcointalk_url block_explorer_url replaced_by markets_count cryptocontrol_coin_id used_for_pricing])
        expect(subject.first['id']).to eq('BTC')
      end
    end

    include_examples 'multiple_currencies'
  end

  describe '#ticker' do
    subject { described_class.ticker(parameters) }

    context 'single currency' do
      let(:parameters) { { ids: 'BTC' } }

      it 'returns one metadata' do
        expect(subject.size).to eq(1)
        expect(subject.first.keys).to eq(%w[id currency symbol name logo_url status price
                                            price_date price_timestamp circulating_supply max_supply market_cap market_cap_dominance num_exchanges num_pairs num_pairs_unmapped first_candle first_trade first_order_book rank rank_delta high high_timestamp 1d 7d 30d 365d ytd])
        expect(subject.first['id']).to eq('BTC')
      end
    end

    include_examples 'multiple_currencies'
  end

  describe '#sparkline' do
    subject { described_class.sparkline(parameters) }

    context 'single currency' do
      let(:parameters) { { ids: 'BTC' } }

      it 'returns one metadata' do
        expect(subject.size).to eq(1)
        expect(subject.first.keys).to eq(%w[currency timestamps prices])
        expect(subject.first['currency']).to eq('BTC')
      end
    end

    include_examples 'multiple_currencies'
  end

  describe '#rate_conversion' do
    let(:ids) { raise 'Define it!' }
    let(:start) { DateTime.yesterday }
    subject { described_class.rate_conversion(ids: ids, start: start) }

    context 'with parameters' do
      let(:ids) { %w[BTC ETH] }
      it 'returns the rate' do
        expect(subject.keys).to eq(%w[ids start rate])
      end

      context 'start as string' do
        let(:start) { DateTime.yesterday.to_s }

        it 'returns the rate' do
          expect(subject.keys).to eq(%w[ids start rate])
        end
      end
    end

    context 'bad parameters' do
      let(:ids) { %w[BTC] }
      it 'raise an error' do
        expect { subject.keys }.to raise_error
      end
    end
  end
end
