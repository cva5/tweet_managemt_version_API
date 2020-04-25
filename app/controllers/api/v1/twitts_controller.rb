module Api 
  module V1
   class TwittsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request!, only: [:index, :create]

  def index
    if current_user.admin
      twits = Twit.all
    else 
      twits = current_user.twits 
    end 

    render json: {twits: twits}
  end

  def create
    params.permit!
    twit = current_user.twits.create(tweet: params[:tweet])

    if twit 
      render json: {status: 'success'}
    else 
      render json: {status: 'failure'}
    end
   end
  end
 end
end
