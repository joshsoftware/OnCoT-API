# frozen_string_literal: true

module Api
  module V1
    module Admin
      class RulesController < ApiController
        before_action :authenticate_user!
        load_and_authorize_resource
        before_action :rule_finder, only: %i[update destroy]

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
          drive = Drive.find(params[:drive_id])
          rules = drive.rules

          render_success(data: { rules: serialize_resource(rules, RuleSerializer) },
                         message: I18n.t('index.success', model_name: Rule))
        end

        def update
          if @rule.update(rule_params)
            render_success(data: { rule: serialize_resource(@rule, RuleSerializer) },
                           message: I18n.t('update.success', model_name: Rule))
          else
            render_error(message: I18n.t(@rule.errors.messages, model_name: Rule), status: 400)
          end
        end

        def destroy
          if @rule.destroy
            render_success(message: I18n.t('destroy.success', model_name: Rule))
          else
            render_error(message: I18n.t(@rule.errors.messages, model_name: Rule), status: 400)
          end
        end

        private

        def rule_finder
          @rule = Rule.find(params[:id])
        end

        def rule_params
          params.permit(:id, :type_name, :description, :drive_id)
        end
      end
    end
  end
end
