class Api::V1::Admin::ReviewersController < ApiController

  # GET api/v1/admin/reviewers 
  def index
    role = Role.where(name: 'reviewer').first
    @users = User.where(role: role)
    #UserSerializer.new(@user).as_json
    render_success(data: {users: serialize_resource( @users, UserSerializer )}, message: I18n.t('index.success', model_name: 'Reviewer'))

  end

  # POST api/v1/admin/reviewers 
  def create
    #@user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      #byebug
      render_success(data: {user: serialize_resource( @user, UserSerializer )}, message: I18n.t('create.success', model_name: 'Reviewer') , status: 201)
    end
  end

  # GET api/v1/admin/reviewers/:id  
  def show
    @user = User.find_by_id(params[:id])
      if @user
        render_success(data: {user: serialize_resource( @user, UserSerializer )}, message: I18n.t('show.success', model_name: 'Reviewer'))
      end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update(user_params)
      #byebug
      render_success(data: {user: serialize_resource( @user, UserSerializer )}, message: I18n.t('update.success', model_name: 'Reviewer'))
    end
  end

  # DELETE /reviewers/1 
  def destroy
    @user = User.find_by_id(params[:id])
    if @user.delete
      render_success(data: {user: serialize_resource( @user, UserSerializer )}, message: I18n.t('destroy.success', model_name: 'Reviewer'))
    end
  end

  private

  # Strong Params
  def user_params
    params.permit(:first_name, :last_name, :email, :organization_id, :role_id, :password)
  end

end
