class ProblemsController < ApiController
  def show
    drive = Drive.find_by(id: params[:id])

    problem = drive.problems.first
    if problem
      render_success(data: problem, message: 'Success')
    else
      render_error(message:'Problems not exist')
    end
  end
end