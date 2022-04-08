# frozen_string_literal: true

class UpdateWalletAssetsJob
  include Sidekiq::Job
  sidekiq_options queue: 'priority'

  def perform
    assets = Asset.where(id: WalletItem.group(:asset_id).pluck(:asset_id))
    assets.each do |asset|
      UpdateAssetQuoteJob.perform_async(asset.symbol)
    end
  end
end
