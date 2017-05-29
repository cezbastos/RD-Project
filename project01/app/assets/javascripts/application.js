// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//

////////////////////////////////////// [BEGIN] User tracking code //////////////////////////////////////
function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function update_accessed_pages(target="") {

	/*var user_ip;
	$.get("http://ipinfo.io", function(response) {
		user_ip = response.ip;
	}, "jsonp");*/

	if (target == "") {
		target = window.location.href
	}

	var d = new Date(); // miliseconds date
	var page = ''+target+'|'+d.getTime(); // accessed_page|timestamp

	var arr = getCookie('accessed_pages').split('|');
	arr.push(page);
	
	var str_cookie;
	str_cookie = arr.join('|')

	document.cookie = "accessed_pages="+str_cookie+"; path=/;";

}

function send_info() {

	var mail=getCookie('mail');

	if (mail != "") {
		$.ajax({
	    	url: 'http://localhost:2000', // using default port 2000
			type: 'POST',
	    	data: {
	        	email: mail,
	        	page: getCookie('accessed_pages')
	    	},
		});

		// clear accessed pages after sending info
		document.cookie = "accessed_pages=; path=/;"
	}
	
}

$(function(){

   	update_accessed_pages(); // update cookies
   	send_info(); // send info to the TCP server in case of page load

});

$(document).ready(function(){

    $('html').click(function(event){
    	if (event.target.localName == 'a') { // link clicked
    		var addressValue = ''+event.target+''; // $(this).attr("href");

    		var expression = "(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9]\.[^\s]{2,})"; // url regular expression
			var regex = new RegExp(expression);

    		if (addressValue.match(regex)) {
        		console.log("accessing page:"+event.target); 
        		update_accessed_pages(event.target); // update cookies
        		send_info(); // send info to the TCP server in case of accessing a link
    		}
   

    	}
    });

    // check submission events and search for email fields
    $('html').submit(function(event){
        if ($("input[type='email']").val() != undefined && $("input[type='email']").val() != "") {
    		mail=$("input[type='email']").val();
			document.cookie = "mail="+mail+"; path=/;"; // update cookie for mail
    		send_info(); // send info to the server as a new user has been registered
    	}
    });

});

//////////////////////////////////////  [END]  User tracking code //////////////////////////////////////
