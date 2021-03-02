class ProblemsController < ApiController
  def show
    problem = Problem.find(params[:id])
    if problem.valid?
      render json: { title: problem.title, description: problem.description }
    else
      render_error(message: 'Problem not exists')
    end
  end
end
