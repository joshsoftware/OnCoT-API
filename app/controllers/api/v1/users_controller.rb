# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def accept_invite # rubocop:disable Metrics/AbcSize
        user = User.find_by(invitation_token: params[:invitation_token])

        if !user
          render json: { message: I18n.t('token.invalid'), status: 404 }
        elsif user.update(password: params[:password], mobile_number: params[:mobile_number], invitation_accepted_at: DateTime.current,
                          first_name: params[:first_name], last_name: params[:last_name], invitation_token: nil)
          render_success(data: { user: serialize_resource(user, UserSerializer) },
                         message: I18n.t('invitation.accepted'))
        else
          render_error(message: I18n.t('error.message'))
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :email, :role_id,
                      :password, :password_confirmation, :invitation_token, :mobile_number)
      end
    end
  end
end
