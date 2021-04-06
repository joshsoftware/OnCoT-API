# frozen_string_literal: true

module DriveResult
  module ClassMethods
    def fetch_results(problem_id, drive_id)
      calculate_result(problem_id, drive_id)
      scores = []
      end_times = []
      id = []
      drives_candidates = find_drive_candidates(drive_id)
      drives_candidates.each do |drives_candidate|
        id << drives_candidate.candidate_id
        scores << drives_candidate.score
        end_times << get_end_time(drives_candidate)
      end
      [id, scores, end_times]
    end

    private

    def calculate_result(problem_id, drive_id)
      drives_candidates = find_drive_candidates(drive_id)
      drives_candidates.each do |drives_candidate|
        next if drives_candidate.score&.present?

        c_id = drives_candidate.id
        submits = Submission.joins(test_case_results: [:test_case]).where(drives_candidate_id: c_id, problem_id: problem_id,
                                                                          test_case_results: { is_passed: true })
        submits = submits.select('submissions.id as submission_id, sum(test_cases.marks) as marks').group('submissions.id')
        final_marks = submits.map(&:marks).max
        drives_candidate.update(score: final_marks)
      end
    end

    def find_drive_candidates(drive_id)
      drive = Drive.find(drive_id)
      drive.drives_candidates
    end

    def get_end_time(drives_candidate)
      drives_candidate.completed_at.present? ? drives_candidate.completed_at.iso8601 : drives_candidate.end_time.iso8601
    end
  end
end

