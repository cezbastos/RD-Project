# RD-Project

This project consists of two separate applications:

	* project01: Simple example site that a common user access, with a contact form
	* tracker_view: Application that shows the user activity

## Specification

project01: The file app/assets/javascripts/application.js contains a block of code responsible for monitor the user activity on the page. It can be ported to any other website.

tracker_view: This project contains a simple index page which shows the user activity received.

In order to listen to the user activity from other sites, a rake task was created: tracker:tcp_server_task.

After starting the rails application, this task must be running to receive incoming data from other sites. Execute the following command to run it:

	rake tracker:tcp_server_task // the current directory should be the tracker_view