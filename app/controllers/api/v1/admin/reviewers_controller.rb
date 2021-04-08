# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReviewersController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource class: User

        def index
          organization = Organization.find(params[:organization_id])
          role = Role.find_by(name: 'Reviewer')
          reviewers = organization.users.where(role_id: role.id)

          render_success(data: { reviewers: serialize_resource(reviewers, UserSerializer) },
                         message: I18n.t('index.success', model_name: 'Reviewer'))
        end

        def create
          reviewer = User.new(reviewer_params.merge(organization_id: current_user.organization_id))
          if reviewer.save
            render_success(data: { reviewer: serialize_resource(reviewer, UserSerializer) },
                           message: I18n.t('create.success', model_name: 'Reviewer'), status: :created)
          else
            render_error(message: I18n.t('create.failed', model_name: 'Reviewer'))
          end
        end

        def show
          reviewer = User.find(params[:id])
          if reviewer
            render_success(data: { reviewer: serialize_resource(reviewer, UserSerializer) },
                           message: I18n.t('show.success', model_name: 'Reviewer'))
          else
            render_error(data: { reviewer: serialize_resource(reviewer, UserSerializer) },
                         message: I18n.t('show.failed', model_name: 'Reviewer'))
          end
        end

        def update
          reviewer = User.find(params[:id])
          if reviewer.update(reviewer_params)

            render_success(data: { reviewer: serialize_resource(reviewer, UserSerializer) },
                           message: I18n.t('update.success', model_name: 'Reviewer'))
          else
            render_error(data: { reviewer: serialize_resource(reviewer, UserSerializer) },
                         message: I18n.t('update.failed', model_name: 'Reviewer'))
          end
        end

        private

        def reviewer_params
          params.permit(:first_name, :last_name, :email, :role_id, :password)
        end
      end
    end
  end
end
