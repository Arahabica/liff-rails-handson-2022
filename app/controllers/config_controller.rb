class ConfigController < ApplicationController
  skip_before_action :authenticate_user!

  def liff_id
    liffId = ENV['LIFF_ID']
    return render json: { liffId: liffId }, status: :ok
  end
end
