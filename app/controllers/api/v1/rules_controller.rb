# frozen_string_literal: true

module Api
  module V1
    class RulesController < ApiController
      def index
        drive = Drive.find(params[:id])
        rules = drive.rules

        render_success(data: { rules: serialize_resource(rules, RuleSerializer) },
                       message: I18n.t('index.success', model_name: Rule))
      end
    end
  end
end
