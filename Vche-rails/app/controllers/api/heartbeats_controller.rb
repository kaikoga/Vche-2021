class Api::HeartbeatsController < ActionController::Base
  def show
    render json: { result: User.exists? }
  end
end
