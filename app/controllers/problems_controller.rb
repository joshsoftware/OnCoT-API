# frozen_string_literal: true

class ProblemsController < ApiController
  before_action :find_problem
  def display
    if (problem = @drive_problem.problem)
      render_success(data: problem, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'), status: 404)
    end
  end

  def find_problem
    id = params[:id].to_s
    @drive_problem = DrivesProblem.find_by(drive_id: id)
    return render_error(message: I18n.t('not_found.message'), status: :not_found) if @drive_problem.blank?
  end
end
