# frozen_string_literal: true

class AssessmentReportJob < ApplicationJob
    def perform(params)
      params.merge(status: 'completed')
    
        body = ParamAiApi
               .new(params)
               .post
      data = body['assessment_schedule_id'] ? body : 'error'        
      # if body['assessment_schedule_id']
      #   byebug
      #   data = body
      # else
      #   r 'error'}
      # end
      data
    end
end
  