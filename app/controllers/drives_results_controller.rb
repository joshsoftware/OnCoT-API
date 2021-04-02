# frozen_string_literal: true

class DrivesResultsController < ApiController
  def show
    calculate_result
    result = fetch_results
    render_success(data: { candidate_id: result.first, score: result[1], end_time: result[2] },
                   message: I18n.t('success.message'))
  end

  private

  def calculate_result
    drives_candidates = DrivesCandidate.where(drive_id: params[:id])
    drives_candidates.each do |drives_candidate|
      c_id = drives_candidate.candidate_id
      submissions = Submission.joins(test_case_results: [:test_case]).where(candidate_id: c_id, problem_id: params[:problem_id],
                                                                            test_case_results: { is_passed: true })
      submissions = submissions.select('submissions.id as submission_id, sum(test_cases.marks) as marks').group('submissions.id')
      final_marks = submissions.map(&:marks).max
      drives_candidate.update(score: final_marks)
    end
  end

  def fetch_results
    scores = []
    end_times = []
    id = []
    drives_candidates = DrivesCandidate.where(drive_id: params[:id])
    drives_candidates.each do |drives_candidate|
      id << drives_candidate.candidate_id
      scores << drives_candidate.score
      end_times << get_end_time(drives_candidate)
    end
    [id, scores, end_times]
  end

  def get_end_time(drives_candidate)
    time = if !drives_candidate.completed_at.nil?
             drives_candidate.completed_at
           else
             drives_candidate.end_time
           end
    time.iso8601
  end
end
