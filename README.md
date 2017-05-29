# RD-Project

This project consists of two separate applications:

	* project01: Simple example site that a common user access, with a contact form
	* tracker_view: Application that shows the user activity

## Dependencies

After cloning this project, access both application folders and run:

	1) bundle install // make sure to have the bundler install - (gem install bundler)
	2) Edit the file config/database.yml to suit your database configuration
	3) rake db:create // create the database
	4) rake db:migrate // create the database

The installation of the following binaries may be required if they are not present on the system:

	* postgresql
	* libpq-dev
	* nodejs
	* bundler
	* git
	* heroku

## Specification

### project01

The file [application.js](https://github.com/cezbastos/RD-Project/blob/master/project01/app/assets/javascripts/application.js) contains a block of code responsible for monitor the user activity on the page. It can be ported to any other website.

### tracker_view

This project contains a simple index page which shows the user activity received.

In order to listen to the user activity from other sites, a rake task was created: [tracker.rake](https://github.com/cezbastos/RD-Project/blob/master/tracker_view/lib/tasks/tracker.rake)

After starting the rails application, this task must be running to receive incoming data from other sites. Execute the following command to run it:

	rake tracker:tcp_server_task // the current directory should be the tracker_view

### [Example] Running the solution

1) Start the tracker_view application and the rake task

	$ rails server -d -p 3001
	$ rake tracker:tcp_server_task

2) Start the project01 application, and access it to generate activities (requests to be received by tcp_server_task)

	$ rails server -p 3000

3) Access a few pages under http://localhost:3000, then register yourself as a contact

4) Access http://localhost:3001 to see your activity recorded - The tcp_server_tasks also display logs in its console
