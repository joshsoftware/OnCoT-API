class Api::V1::Admin::ReviewersController < ApplicationController
  
  # To avoid CSRF token authenticity.
  protect_from_forgery with: :null_session

  # GET api/v1/admin/reviewers 
  def index
    @user = User.all.where(role_id: 2)
    render json: @user.as_json
  end

  # POST api/v1/admin/reviewers 
  def create
    #@user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      #byebug
      render json: @user.as_json
    end
  end

  # GET api/v1/admin/reviewers/:id  
  def show
    @user = User.find(params[:id])
      if @user
        render json: @user.as_json
      end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #byebug
      render json: @user.as_json
    end
  end

  # DELETE /reviewers/1 
  def destroy
    @user = User.find(params[:id])
    if @user.delete
      render json: @user.as_json    
    end
  end

  private

  # Strong Params
  def user_params
    params.permit(:first_name, :last_name, :email, :organization_id, :role_id, :password)
  end

end
