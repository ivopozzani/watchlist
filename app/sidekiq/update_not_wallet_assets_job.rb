# frozen_string_literal: true

require 'sidekiq-scheduler'

class UpdateNotWalletAssetsJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  def perform
    assets = Asset.where.not(id: WalletItem.group(:asset_id).pluck(:asset_id))
    assets.each do |asset|
      UpdateAssetQuoteJob.perform_async(asset.symbol)
    end
  end
end
