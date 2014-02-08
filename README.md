RailsGirls
==========

Management App for RailsGirls


HOW TO DEPLOY
for another RailsGirls group
(cloning an existing Heroku app and pushing local repo)

Prerequisites:
1. account on www.heroku.com (with credit card information)
2. install heroku toolbelt
2. install git
3. install rails

What to do:

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
git push app_name mongodb:master

(6.)
create admin in rails console

heroku run rails c --app app_name
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
git push app_name mongodb:master

(6.)
create admin in rails console

heroku run rails c --app app_name
> User.delete_all
> User.create(:name=>"admin", :email=>"admin@railsgirls.com", :password=>"rgdemo14", :password_confirmation=>"rgdemo14")