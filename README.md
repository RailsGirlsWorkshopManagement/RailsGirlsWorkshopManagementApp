# RailsGirlsWorkshopManagementApp

The Application helps the very independent Rails Girls groups located all over the world to manage and organize their workshop registration process. Main focus of the project lays on cooperation and the development for multiple teams who used, tested and evaluated this product since October 2013.

#### See for yourself: 
- An [http://railsgirls-demo.herokuapp.com/admin](http://railsgirls-demo.herokuapp.com/admin "http://railsgirls-demo.herokuapp.com/admin")
- Email: admin@railsgirls.com
- Password: rgdemo14

## Functionality:

- Create multiple workshops
- Publish a workshop --> Participants can select a workshop and register
- great usability throuh interactive tour.

### Form-Management:
- Create a new participant form for a workshop
- Create a private coach form for a workshop
- Or use an existing form from a previous workshop and modify it
- Coaches can register through a private link

### RegistrationData-Management:
- Filter the registrations you want to display with various methods
- Accept or reject Registrations
- Export the selected registration data to csv or excel

### Email-Management:
- Insert your smtp settings to use the mail functionality in the admin interface under app settings
- Edit the default template of the Confirmation Email which gets sent to all Admins and the participant after a registration
- The E-Mail is personalized and contains information about the workshop and a link to cancel a registration
- Send a manual email to all participants, admins, coaches, rejected participants, accepted participants

### GlobalData-Management:
- Firstname, lastname, email and information about the workshop gets posted to a global Server for international statistics.


# How to deploy:

## Prerequisites

- account on www.heroku.com (with credit card information)
- install heroku toolbelt (https://toolbelt.heroku.com/)
- install git (http://git-scm.com/downloads)


## Instructions
1.Download Project
  * open your terminal
  * go to the directory you want to create the project by using >$ cd
  * run the following command to download the repository:

```
$ git clone git@github.com:RailsGirlsWorkshopManagement/RailsGirlsWorkshopManagementApp.git
```

2.Create Heroku App
  * run the following commands to login to your heroku accound and create your app:

```
$ heroku login
//enter heroku credentials and generate a public key if non-existing
$ heroku create app-name --addons mongohq
```


3.Create git remote
  * add the following in ".git/config" (the folder .git is normally hidden so change your preferences if you can't find it)

```
 [remote "app_name"]
        url = git@heroku.com:app_name.git
        fetch = +refs/heads/*:refs/remotes/heroku/*
```

4.Settings for Environment Variables
  *run the following command in the terminal:

```
$ heroku labs:enable user-env-compile --app app_name
```

5.Push your app to heroku

```
$ git push app_name master
```

6.Create admins
create migration and admin in rails console by running the following commands:

```
$ heroku run rake db:migrate --app app-name
$ heroku run rails c --app app_name
> User.delete_all
> User.create(:name=>"admin", :email=>"admin@railsgirls.com", :password=>"password", :password_confirmation=>"password")
```

# MIT License:

Copyright (c) 2014 Till Leinen, Johannes Engl

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
