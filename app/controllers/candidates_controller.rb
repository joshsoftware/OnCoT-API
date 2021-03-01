class CandidatesController < ApiController

    def create
        candidate = Candidate.create(candidate_params)
    end

    def update
        @candidate = Candidate.find(params[:id])
        if (@candidate.update(candidate_params))
          render :json => {:msg => "successfully added details", :info => @candidate}
        else
          render :json => { :errors => @candidate.errors.as_json }, :status => 420
        end
    end
    
    private
    def candidate_params
        params.permit(:first_name, :last_name, :email, :is_profile_complete, :drive_id, :invite_status, :created_at, :updated_at)
    end
    
end
