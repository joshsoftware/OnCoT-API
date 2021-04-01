# frozen_string_literal: true

module Api
  module V1
    module Admin
      class RulesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource

        def create
          rule = Rule.new(rule_params)
          if rule.save
            render_success(data: { rule: serialize_resource(rule, RuleSerializer) },
                           message: I18n.t('create.success', model_name: Rule))
          else
            render_error(message: rule.errors.messages, status: 400)
          end
        end

        def index
          drive_id = Drive.find(params[:id])
          rules = Rule.where(drive_id: drive_id)

          render_success(data: { rules: serialize_resource(rules, RuleSerializer) },
                         message: I18n.t('index.success', model_name: Rule))
        end

        def update
          rule = Rule.find(params[:id])

          if rule.update(rule_params)
            render_success(data: { rule: serialize_resource(rule, RuleSerializer) },
                           message: I18n.t('update.success', model_name: Rule))
          else
            render_error(message: I18n.t(rule.errors.messages, model_name: Rule), status: 400)
          end
        end

        private

        def rule_params
          params.permit(:type_name, :description, :drive_id)
        end
      end
    end
  end
end
