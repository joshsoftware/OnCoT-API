class ProblemsController < ApiController
  def show
    drives_problem = DrivesProblem.find_by_id(params[:id])
    problem = Problem.find_by_id(drives_problem.problem_id)
    # drive = Drive.find_by(id: params[:id])

    # problem = drive.problems.first
    if problem
      render_success(data: problem, message: 'Success')
    else
      render_error(message:'Problems not exist')
    end
  end
end