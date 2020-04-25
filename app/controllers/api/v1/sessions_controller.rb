require 'securerandom'

module Api 
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def login
        params.permit!
        user = User.find_by(email: params[:email])

        if user && user.enc_password == params[:password]
          jwt = JsonWebToken.encode({user_id: user.id})

          render json: {status: 'success', user: user.as_json(only: :name), token: jwt}
        else
          render json: {status: 'failure'}
        end  
      end

      def signup
        params.permit!
        user = User.new(params[:session])
        user.enc_password = params[:session][:password]

        if user.save
          jwt = JsonWebToken.encode({user_id: user.id})

          render json: {status: 'success', user: user.as_json(only: :name), token: jwt}
        else 
          render json: {status: 'failure',errors: user.errors.full_messages.join(',')}
        end
      end

      def forgot_password
        user = User.find_by(email: params[:email])
        random_string = SecureRandom.hex
        user.reset_token = random_string

        if user.save 
          render json: {status: 'success', reset_link: "#{request.host_with_port}/reset_password?token=#{random_string}"}
        else 
          render json: {status: 'failure'}
        end
      end 
      
      def reset_password 
        token = params[:session][:token]
        user = User.find_by(reset_token: token)
      
        if user.nil?
          render json: {status: 'failure'}
        else
          user.enc_password = params[:session][:password]
          random_string = SecureRandom.hex
          user.reset_token = random_string  

          if user.save
            render json: {status: 'success'}
          else 
            render json: {status: 'failure'}
          end
        end
      end
    end
  end 
end
