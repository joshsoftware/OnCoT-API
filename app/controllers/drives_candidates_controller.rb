class DrivesCandidatesController < ApplicationController

    respond_to :xml, :json, :csv

    def index
      respond_with DrivesCandidate.all
    end
end
