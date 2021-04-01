# frozen_string_literal: true

class ProblemsController < ApiController
  def index
    if (drive_problem = DrivesProblem.find_by(drive_id: params[:id]))
      problem = Problem.find(drive_problem.problem_id)
      render_success(data: problem, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'), status: 404)
    end
  end
end
