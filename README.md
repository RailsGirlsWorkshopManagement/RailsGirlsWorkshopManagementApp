RailsGirlsWorkshopManagementApp
===============================

The Application helps the very independent Rails Girls groups located all over the world to manage and organize their workshop registration process. Main focus of the project lays on cooperation and the development for multiple teams who used, tested and evaluated this product since October 2013.

See for yourself: railsgirls-demo.herokuapp.com/admin
Email: admin@railsgirls.com
Password: rgdemo14

Functionality:

- Create multiple workshops
- Publish a workshop --> Participants can select a workshop and register
- great usability throuh interactive tour.

Form-Management:
- Create a new participant form for a workshop
- Create a private coach form for a workshop
- Or use an existing form from a previous workshop and modify it
- Coaches can register through a private link

RegistrationData-Management:
- Filter the registrations you want to display with various methods
- Accept or reject Registrations
- Export the selected registration data to csv or excel

Email-Management:
- Edit the default template of the Confirmation Email which gets sent to all Admins and the participant after a registration
- The E-Mail is personalized and contains information about the workshop and a link to cancel a registration
- Send a manual email to all participants, admins, coaches, rejected participants, accepted participants

GlobalData-Management:
- Firstname, lastname, email and information about the workshop gets posted to a global Server for international statistics.


===============================
HOW TO DEPLOY
===============================

PREREQUISITES:

1. account on www.heroku.com (with credit card information)

2. install heroku toolbelt (https://toolbelt.heroku.com/)

3. install git (http://git-scm.com/downloads)


What to do:
1.
- download the repository
- open your terminal
- go to the directory of the downloaded folder

2.
-run the following commands:
	$ heroku login
		--> enter heroku credentials and generate a public key if non-existing
	$ heroku create app-name --addons mongohq:free,shared-database:5mb

3.
add the following in ".git/config"

[remote "app_name"]
        url = git@heroku.com:app_name.git
        fetch = +refs/heads/*:refs/remotes/heroku/*

4.
$ heroku labs:enable user-env-compile --app app_name

5.
$ heroku addons:add mongohq --app app_name

6.
$ git push app_name master

7.
create admin in rails console

$ heroku run rails c --app app_name
> User.delete_all
> User.create(:name=>"admin", :email=>"admin@railsgirls.com", :password=>"rgdemo14", :password_confirmation=>"rgdemo14")


===============================
===============================


HOW TO DEPLOY
for another RailsGirls group
(cloning an existing Heroku app and pushing local repo)

1.
heroku fork -a existing_app new_app

2.
add the following in ".git/config"

[remote "app_name"]
        url = git@heroku.com:app_name.git
        fetch = +refs/heads/*:refs/remotes/heroku/*

3.
heroku labs:enable user-env-compile --app app_name

4.
heroku addons:add mongohq --app app_name

5.
git push app_name master

6.
create admin in rails console

heroku run rails c --app app_name
> User.delete_all
> User.create(:name=>"admin", :email=>"admin@railsgirls.com", :password=>"rgdemo14", :password_confirmation=>"rgdemo14")