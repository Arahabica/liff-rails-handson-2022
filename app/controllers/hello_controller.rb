class HelloController < ApplicationController
  before_action :authenticate_user!
  def index
    message = "こんにちは、#{current_user.name}さん"
    render json: { message: message }, status: :ok
  end
end
