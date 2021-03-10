class ProblemsController < ApiController
  before_action :find_problem
  def show
    problem = Problem.find_by(id: @drives_problem.problem_id)
    if problem
      render_success(data: problem, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'))
    end
  end

  private

  def find_problem
    token = params[:token].to_s
    return render_error(message: I18n.t('token_not_found.message'), status: :not_found) if token.blank?

    drive_candidate = DrivesCandidate.find_by(token: token)
    drive = Drive.find_by(id: drive_candidate.drive_id)
    @drives_problem = DrivesProblem.find_by(id: drive.id)
  end
end
