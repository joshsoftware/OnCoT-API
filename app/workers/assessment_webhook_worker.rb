class AssessmentWebhookWorker
  include Sidekiq::Worker

  def perform(drive_candidate_id)
    drive_candidate = DrivesCandidate.where(id: drive_candidate_id).first
    if drive_candidate.present?
      params = { key: ENV['PARAM_API_KEY'],
                 assessment_schedule_id: drive_candidate.uuid,
                 score: drive_candidate.score,
                 status: 'completed'
               }
      status = ParamAiApi.new(params).post
      if status != 200
        AssessmentWebhookWorker.perform_in(10.minutes, drive_candidate_id)
      end
    end
  end
end
