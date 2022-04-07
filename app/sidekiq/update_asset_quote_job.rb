# frozen_string_literal: true

class UpdateAssetQuoteJob
  include Sidekiq::Job
  sidekiq_options retry: 5

  sidekiq_retries_exhausted do |job, exception|
    asset = Asset.find_by!(symbol: job['args'].first.upcase, currency: 'BRL')
    quote = Quote.create(price: 0, current: false, asset_id: asset.id)
    Alert.create!(message: "Something went wrong, error: #{exception}", quote_id: quote.id)
  end

  def perform(asset_ticker, currency = 'BRL')
    asset = Asset.find_or_create_by(symbol: asset_ticker.upcase, currency: currency)
    asset_price = GetAssetQuoteService.call(asset_ticker)
    Quote.create(price: asset_price, current: true, asset_id: asset.id)
  end
end
