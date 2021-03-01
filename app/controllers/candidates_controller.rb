class CandidatesController < ApplicationController
 
    def update
        @candidate = Candidate.find(params[:id])
        if (@candidate.update(candidate_params))
          render :json => {:msg => "success", :info => @candidate}
        else
          render :json => { :errors => @candidate.errors.as_json }, :status => 420
        end
    end
    
    private
    def candidate_params
        params.permit(:first_name, :last_name, :email, :is_profile_complete, :invite_status, :drive_id)
    end
    
end
