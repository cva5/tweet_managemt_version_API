module Api
  module V2
    class SessionsController < Api::V1::SessionsController

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
    end
  end
end