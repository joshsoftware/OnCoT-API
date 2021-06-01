# frozen_string_literal: true

module Api
  module V1
    module Admin
      class UsersController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource class: User

        def create
          user = User.new(user_params.merge(organization_id: current_user.organization_id))
          if user.save
            render_success(data: { reviewer: serialize_resource(user, UserSerializer) },
                           message: I18n.t('create.success', model_name: 'User'), status: :created)
          else
            render_error(message: I18n.t('create.failed', model_name: 'User'))
          end
        end

        def update
          user = User.find(params[:id])
          if user.update(user_params)

            render_success(data: { user: serialize_resource(user, UserSerializer) },
                           message: I18n.t('update.success', model_name: 'User'))
          else
            render_error(data: { user: serialize_resource(user, UserSerializer) },
                         message: I18n.t('update.failed', model_name: 'User'))
          end
        end

        def index
          organization = Organization.find(params[:organization_id])
          users = organization.users

          render_success(data: { users: serialize_resource(users, UserSerializer) },
                         message: I18n.t('index.success', model_name: 'User'))
        end

        def invite_user
          email = params[:email]
          @role = params[:role]
          user = User.find_by(email: email, organization_id: current_user.organization.id)

          if user
            render json: {message: I18n.t('user.exist') , status: 400 }
          else
            user = User.create(
              email: email,
              role_id: @role,
              organization_id: current_user.organization.id,
              password: SecureRandom.hex(10),
              invitation_token: SecureRandom.hex(50),
              invitation_sent_at: DateTime.current
            );
            render_error(message: I18n.t('create.failed', model_name: 'User')) unless user
            UserMailer.user_invitation_email(user.email, @role, current_user, user.invitation_token).deliver_later

            render_success(message: 'yes')
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
end
