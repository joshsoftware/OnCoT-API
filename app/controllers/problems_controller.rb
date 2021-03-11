# frozen_string_literal: true

class ProblemsController < ApiController
  def display
    problem = Problem.find_by(drive_id: params[:id])
    if problem
      render_success(data: problem, message: I18n.t('success.message'))
    else
      render_error(message: I18n.t('not_found.message'), status: 404)
    end
  end
end
