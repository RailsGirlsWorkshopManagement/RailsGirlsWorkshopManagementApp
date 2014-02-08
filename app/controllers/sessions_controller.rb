class SessionsController < ApplicationController

def new

end

def destroy
	sign_out
    redirect_to home_path
end

def create
	user = User.find_by(email: params[:session][:email].downcase)
	if user && user.authenticate(params[:session][:password])
	# Sign the user in and redirect to the user's show page.
		sign_in user
		redirect_to workshops_path
	else
	# Create an error message and re-render the signin form.
	flash.now[:error] = 'Invalid email/password combination'
		render 'new'
	end
end

end
