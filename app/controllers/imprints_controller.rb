class ImprintsController < ApplicationController
 before_action :authenticate_user!

  def create
    activation_key = params[:activation_key]
    stamp_id = params[:stamp_id]
    user_id = current_user.id
    stamp = Stamp.find(stamp_id)
    if stamp.activation_key != activation_key
      return render json: { error: 'Activation key is invalid.' }, status: :bad_request
    end
    @imprint = Imprint.find_by(user_id: user_id, stamp_id: stamp_id)
    if @imprint.blank?
      # 二重押印はエラーにせず、処理をスキップ
      @imprint = Imprint.create!(user_id: user_id, stamp_id: stamp_id)
    end
  end
end
