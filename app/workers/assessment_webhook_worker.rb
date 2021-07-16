# frozen_string_literal: true

class AssessmentWebhookWorker
  include Sidekiq::Worker

  def perform(drive_candidate_id)
    drive_candidate = DrivesCandidate.where(id: drive_candidate_id).first
    drive = drive_candidate.drive
    return unless drive_candidate.present?

    params = { key: ENV['PARAMS_AI_KEY'], assessment_schedule_id: drive_candidate.uuid, score: drive_candidate.score,
               status: 'completed', report: "#{ENV['MAIN_URL']}/api/v1/drives/#{drive.id}/results/csv_result?drives_candidate_id=#{drive_candidate_id}" }
    status = ParamAiApi.new(params).post
    return unless status != 200

    AssessmentWebhookWorker.perform_in(10.minutes, drive_candidate_id)
  end
end
