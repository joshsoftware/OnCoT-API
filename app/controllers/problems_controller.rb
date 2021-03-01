class ProblemsController < ApplicationController


    def show	
        problem = Problem.find(params[:id])
            if(problem.valid?)
                  render :json => { :title => problem.title, :description => problem.description }
            else
                  render :json => { :error => "Problem not exists"}
            end

    end
end
