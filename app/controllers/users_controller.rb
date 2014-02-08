class UsersController < ApplicationController

def index
  @users = User.all
end

def new
	@user = User.new
end

def create
	@user = User.new(user_params)
  Rails.logger.info(@user.errors.inspect) 
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      print "couldn't save"
      render 'new'
    end
end

def show
	@user = User.find(params[:id])
end

def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
end

def edit  
end

def update
    if @user.update(user_params)
      flash[:success] = "The update was successful"
      redirect_to @user
    else
      render action: 'edit'  
    end
end

private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
