# frozen_string_literal: true

module Api
  module V1
    module Admin
      class UsersController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource class: User

        def index
          organization = Organization.find(params[:organization_id])
          users = organization.users

          render_success(data: { users: serialize_resource(users, UserSerializer) },
                         message: I18n.t('index.success', model_name: 'User'))
        end

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

        def invite_user
          user = User.find_by(email: params[:email], organization_id: current_user.organization.id)
          if user
            render json: {message: I18n.t('user.exist') , status: 400 }
          else
            UserMailer.user_invitation_email(params[:email], params[:role], current_user).deliver_later
            render_success(message: I18n.t('ok.message'))
          end
        end

        private

        def user_params
          params.permit(:first_name, :last_name, :email, :role_id, :password)
        end
      end
    end
  end
end
