class ProblemsController < ApiController
  def show
    # drives_problem = DrivesProblem.find_by(drive_id: params[:id].to_i)
    # problem = Problem.find(problem_id:drives_problem.problem_id)

    drive = Drive.find_by(id: params[:id])
    problem = drive.problems.first
    if problem
      render_success(data: problem, message: 'Success')
    else
      render_error(message:'Problems not exist')
    end
  end
end