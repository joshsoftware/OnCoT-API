# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReviewersController < ApiController
        def index
          users = User.joins(:role).where(roles: { name: 'reviewer' })
          render_success(data: { users: serialize_resource(users, UserSerializer) },
                         message: I18n.t('index.success', model_name: 'Reviewer'))
        end

        def create
          user = User.new(user_params)
          if user.save
            render_success(data: { user: serialize_resource(user, UserSerializer) },
                           message: I18n.t('create.success', model_name: 'Reviewer'), status: :created)
          else
            render_error(message: I18n.t('create.failed', model_name: 'Reviewer'))
          end
        end

        def show
          user = User.find(params[:id])
          if user
            render_success(data: { user: serialize_resource(user, UserSerializer) },
                           message: I18n.t('show.success', model_name: 'Reviewer'))
          else
            render_error(data: { user: serialize_resource(user, UserSerializer) },
                         message: I18n.t('show.failed', model_name: 'Reviewer'))
          end
        end

        def update
          user = User.find(params[:id])
          if user.update(user_params)

            render_success(data: { user: serialize_resource(user, UserSerializer) },
                           message: I18n.t('update.success', model_name: 'Reviewer'))
          else
            render_error(data: { user: serialize_resource(user, UserSerializer) },
                         message: I18n.t('update.failed', model_name: 'Reviewer'))
          end
        end

        private

        def user_params
          params.permit(:first_name, :last_name, :email, :organization_id, :role_id, :password)
        end
      end
    end
  end
end