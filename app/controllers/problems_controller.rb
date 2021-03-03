class ProblemsController < ApiController
  def show
    problem = Problem.find_by_id(params[:id])
    if problem
      render_success(data: problem, message: 'Succeessfully return statement')
    else
      render_error(message: 'Problem not exists')
    end
  end
end
