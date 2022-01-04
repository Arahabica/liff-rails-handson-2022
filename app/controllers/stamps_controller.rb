class StampsController < ApplicationController

  def index
    user_id = 1
    @stamps = Stamp.all
    @imprinted_stamp_ids = Imprint.where(user_id: user_id).map{ |t| t.stamp_id }
  end
  def show
    activation_key = request.query_parameters[:act_key]
    user_id = 1
    stamp_id = params[:id]
    @stamp = Stamp.find(stamp_id)
    @imprinted = Imprint.where(user_id: user_id, stamp_id: stamp_id).any?
    @show_front_image = false
    if activation_key
     if @stamp.activation_key === activation_key
       @show_front_image = true
     else
       return render json: { error: 'Activation key is invalid.' }, status: :bad_request
     end
    end
  end
end
