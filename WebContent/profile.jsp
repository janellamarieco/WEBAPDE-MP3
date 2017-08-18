<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link rel="stylesheet" type = "text/css" href="style.css">
<script type="text/javascript" src="js/script.js"></script>

<script>
var loaded = 0; // loaded photos
var loggedInUser; // logged in user

function loadPhotos(){
	/* load photos */

}

function getCookie(toCheck) {
    var name = toCheck + "=";
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

function changeNavBar() {
      var navBar = document.getElementById('navbar');
      var loggedInUser   =  getCookie("loggedInUser").substring(getCookie("loggedInUser").indexOf("="), getCookie("loggedInUser").length);
      navBar.innerHTML = "<div id = \"navbar\">" 
        				+ "<a href = \"index.jsp\" id = \"title\"> twine </a>" 
        				+ "<div class=\"links\" id = \"navBarLinks\">" 
        				+ "<a class = \"acc\" id = \"profile\">" 
        				+ loggedInUser 
        				+ "</a>" 
        				+ "|" 
        				+ "<a class = \"acc\" id = \"upload\">Upload</a>" 
        				+ "|" 
        				+ "<a class = \"acc\" id = \"logout\">Log Out</a>" 
        				+ "<div id = \"clickedNavBarLinks\">" 
        				+ "</div>" 
        				+ "</div>" 
        				+ "</div>";
}

$(document).ready(function(){
	/* load photos */
	    
	var d = new Date();
    var nDaysExpiry = 21;   // 3 weeks
    
    d.setTime(d.getTime() + (nDaysExpiry*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
   	var loggedInUser = getCookie("loggedInUser").substring(getCookie("loggedInUser").indexOf("="), getCookie("loggedInUser").length);
    var rememberedUser = getCookie("username").substring(getCookie("username").indexOf("="), getCookie("username").length);
  
	var sharedFeedScrollTop = 0;
    var feedScrollTop       = 0;
    
    /* change nav bar */
    if(getCookie("loggedInUser") != "")
    	changeNavBar();
    
    $(document).on('click', '#clickedNavBarLinks', function(event){
        event.stopPropagation();
    });
    
    /* user clicked sign up button */
    $(document).on('click', '#signUpButton', function(event){
        var x = document.getElementById('clickedNavBarLinks');
        var username = document.getElementById('username-input').value;
        var password = document.getElementById('password-input').value;
        var description = document.getElementById('description-input').value;
        
        if(username !== null && password !== null && username !== "" && password !== ""){
        	 $.ajax({
             	"url": "signup",
             	"method": "POST",
             	"success": function(result){
             		if(result === "true"){
             			x.innerHTML = "<div class = \"errorlogin\" style=\"color:green;\">" 
               			  + "Successfully signed up." 
               			  + "</div>" 
               			  + "<div>" 
               			  + "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" 
               			  + "</div>" 
               			  + "<div>" 
               			  + "<input id = \"password-input\" type = \"password\" placeholder=\"Password\" name=\"password\">" 
               			  + "</div>" 
               			  + "<div>" 
               			  + "<input id = \"description-input\" type = \"text\" placeholder=\"description\" name=\"description\">" 
               			  + "</div>" 
               			  + "<button class = \"input-box\" id = \"signUpButton\">Sign Up</button>";
               			  
                		var d = new Date();
                    	var nDaysExpiry = 21;   // 3 weeks
                    	d.setTime(d.getTime() + (nDaysExpiry*24*60*60*1000));
                    	var expires = "expires="+ d.toUTCString();
                    	
                    	if(document.getElementById("rememberme").checked)
                    		document.cookie = "username" + "=" + username + ";" + expires + ";path=/";
                    	
                    	document.cookie = "loggedInUser" + "=" + username + ";path=/";

                    	/* log in user */
                    	window.location.href = "index.jsp";
             		} else {
             			  x.innerHTML = "<div class = \"errorlogin\"  style=\"color:red;\">" 
             			  + username 
             			  + " is already registred!" 
             			  + "</div>" 
             			  + "<div>" 
             			  + "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" 
             			  + "</div>" 
             			  + "<div>" 
             			  + "<input id = \"password-input\" type = \"password\" placeholder=\"Password\" name=\"password\">" 
             			  + "</div>" 
             			  + "<div>" 
             			  + "<input id = \"description-input\" type = \"text\" placeholder=\"description\" name=\"description\">" 
             			  + "</div>" 
             			  + "<button class = \"input-box\" id = \"signUpButton\">Sign Up</button>";
             		}
             	}, "data": {
             			"username": username,
             			"password": password,
             			"description": description
             	}
        	 });
        } else {
        	/* pag walang input */
        	x.innerHTML = 
                "<div class = \"errorlogin\">" 
                + "Please fill in all required fields" 
                + "</div>" 
                + "<div>" 
                + "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" 
                + "</div>" 
                + "<div>" 
                + "<input id = \"password-input\" type = \"password\" placeholder=\"Password\" name=\"password\">" 
                + "</div>" 
                + "<div>" 
                + "<input id = \"description-input\" type = \"text\" placeholder=\"description\" name=\"description\">" 
                + "</div>" 
                + "<button class = \"input-box\" id = \"signUpButton\">Sign Up</button>";
        }
    });
        
    /* user clicked log in button */
    $(document).on('click', '#loginButton',function(event){
    	var x = document.getElementById('clickedNavBarLinks');
        var username = document.getElementById('username-input').value;
        var password = document.getElementById('password-input').value;

         $.ajax({
        	"url": "login",
        	"method": "POST",
        	"success": function(result){
        		if(result){
        			/* LogInServlet + cookies */
        			
        			var d = new Date();
            		var nDaysExpiry = 21;   // 3 weeks
            		d.setTime(d.getTime() + (nDaysExpiry*24*60*60*1000));
            		var expires = "expires="+ d.toUTCString();
            		
            		if(document.getElementById("rememberme").checked)
            			document.cookie = "username" + "=" + username + ";" + expires + ";path=/";
            		
            		document.cookie = "loggedInUser" + "=" + username + ";path=/";
        		 	
            		/* log in user */
        			changeNavBar();
        		} else {
        			x.innerHTML = "<div class = \"errorlogin\">" 
        	        + "Invalid username/password" 
        	       	+ "</div>" 
        	       	+ "<div>"  
        	       	+ "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" 
        	       	+ "</div>" 
        	       	+ "<div>" 
        	       	+ "<input id = \"password-input\" type = \"password\" placeholder=\"Password\"  name=\"password\">" 
        	       	+ "</div>" 
        	       	+ "<div class = \"checkbox\">" 
        	       	+ "<input id=\"rememberme\" type=\"checkbox\">" 
        	       	+ "<label for=\"rememberme\">Remember Me</label>" 
        	       	+ "</div>" 
        	        + "<button class=\"input-box\" id = \"loginButton\">Log In</button>";
        		}
        	}, "data": {
      	 			"username": username,
       				"password": password
        	}
       	});
        	
    });
    
    /* user clicked log in sa navbar */
    $("#login").click(function(event){
    	event.stopPropagation();
        var x = document.getElementById('clickedNavBarLinks');
        x.style.display = 'block';

        x.innerHTML = "<div>" +
            "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" +
            "</div>" +
            "<div>" +
            "<input id = \"password-input\" type = \"password\" placeholder=\"Password\"  name=\"password\">" +
            "</div>" +
            "<div class = \"checkbox\">" +
            "<input id=\"rememberme\" type=\"checkbox\">" +
            "<label for=\"rememberme\">Remember Me</label>" +
            "</div>" +
            "<button class=\"input-box\" id = \"loginButton\">Log In</button>";
    });
    
    /* user clicked sign up sa navbar */
    $("#signup").click(function(event){
        event.stopPropagation();
        
        var x = document.getElementById('clickedNavBarLinks');
        x.style.display = 'block';

        x.innerHTML = "<div>" +
            "<input id = \"username-input\" type = \"text\"  placeholder=\"Username\" name=\"username\">" +
            "</div>" +
            "<div>" +
            "<input id = \"password-input\" type = \"password\" placeholder=\"Password\" name=\"password\">" +
            "</div>" +
            "<div>" +
            "<input id = \"description-input\" type = \"text\" placeholder=\"Description\" name=\"description\">" +
            "</div>" +
            "<button class = \"input-box\" id = \"signUpButton\">Sign Up</button>";
    });

    /* user clicked log out sa navbar */
    $("#logout").click(function(event){
        document.cookie = "username=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
        document.cookie = "loggedInUser=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";

        window.location.href = "index.jsp";
    });
    
    $("#upload").click(function(event){
        event.stopPropagation();
        var x = document.getElementById('clickedNavBarLinks');
        x.style.display = 'block';

        x.innerHTML = " <form action=\"\" method=\"post\" enctype=\"multipart/form-data\"" +
            " name=\"uploadForm\" id=\"uploadForm\"><div class = \"upload\"><p>Upload file</p><input type=\"file\"" +
            " name=\"file\" id=\"file\" accept=\"image/*\" " +
            "onchange=\"javascript:updateList()\"/>" +
            "<input class=\"uinput\" id=\"utitle\" type=\"text\" placeholder=\"Title\"/>" +
            "<textarea class=\"uinput\" id=\"udesc\" type=\"text\" placeholder=\"Description\"></textarea>" +
            "<input class=\"uinput utags\" id=\"utags\" type=\"text\" placeholder=\"Tags\"/>" +
            "<input id=\"uprivacy\" type=\"checkbox\" />" + "Private" +
            "<input class=\"ushare\" id=\"ushare\" type=\"text\" placeholder=\"Enter username\"/ disabled>" +
            "<p class=\"t2\">Shared With:</p><div class=\"ususers\" id=\"ususers\"></div>" +
            "</div><button id=\"uploadButton\">Submit</button></form>";

        $(document).keyup(function (e){
            var activeElement = document.activeElement;
            if (activeElement.className == "ushare" && (e.keyCode == 32) &&
                document.getElementById('ushare').value.replace(/ /g,'').length != 0){

                var taggedUser = document.createElement("div");
                var copyDiv = "<div id=\"username\">" + document.getElementById('ushare').value + "</div>" +
                    "<div class=\"uexit\" onclick=\"return deleteUser(\'{%=taggedUser%}\', event)\">x</div><br>" +
                    document.getElementById('ususers').innerHTML;

                //add classes
                taggedUser.setAttribute('id', "username");


                taggedUser.innerHTML = "<div id=\"username\">" + document.getElementById('ushare').value + "</div>" +
                    "<div class=\"uexit\" onclick=\"return deleteUser(this.parentElement, event)\">x</div><br>" +
                    document.getElementById('ususers').innerHTML;

                // update check muna if there's a user in the db before adding(?)
                document.getElementById('ususers').append(taggedUser);
                document.getElementById('ushare').value = "";
            }
        });
        
        document.getElementById('uprivacy').addEventListener('click', function(){
            if(document.getElementById('uprivacy').checked)
                $(".ushare").prop('disabled', false);
            else{
                $(".ushare").prop('disabled', true);
                document.getElementById('ususers').innerHTML = "";
            } 
        });
        
        $(document).keyup(function (e){

            var activeElement = document.activeElement;

            if (activeElement.id == "utags" && (e.keyCode == 32)){
                document.getElementById('utags').value = "#" + document.getElementById('utags').value;
                document.getElementById('utags').value = document.getElementById('utags').value.replace(/ /g, " #");
                document.getElementById('utags').value = document.getElementById('utags').value.replace(/##/g, "#");
                document.getElementById('utags').value = document.getElementById('utags').value.replace(/#&nbsp;&nbsp;#/g, "#");
                document.getElementById('utags').value = document.getElementById('utags').value.replace(/# #/g, "#");
            }
        });
    });

    
    /* user clicked upload button */
    $("#uploadButton").click(function(event){

        // update db (save images)
        
    });
    
    /* $("#profile").click(function(event){
        window.location.href = "profile.jsp#" + loggedInUser;
    }); */
    
    /* $(document).on('click', '#username', function(){
        var userId = $(this).attr('username');
        window.location.href = "profile.jsp#" + userId;
    }); */
    
    $("#checkBoxPane").click(function(event){

        if(document.getElementById("checkBoxPane").checked){

            var feed = document.getElementById('feed');
            var sharedFeed = document.getElementById('sharedFeed');


            feedScrollTop       =  document.body.scrollTop;
            document.getElementById('a1').innerHTML = "Shared Photos";
            //		                $('body, html').animate({ scrollLeft: $(this).width }, 700);

            feed.style.display = "none";
            sharedFeed.style.display = "block";
            document.body.scrollTop  = sharedFeedScrollTop;
        } else{


            var feed = document.getElementById('feed');
            var sharedFeed = document.getElementById('sharedFeed');

            sharedFeedScrollTop = document.body.scrollTop;
            document.getElementById('a1').innerHTML = "Public Photos";
            // $('body, html').animate({ scrollLeft: 0 }, 700);

            sharedFeed.style.display = "none";
            feed.style.display = "block";
            document.body.scrollTop  = feedScrollTop;
        }
    });
    
    $(window).click(function(){
        var x = document.getElementById('clickedNavBarLinks');
        x.style.display = 'none';
    });

    /* scroll up */
    $(window).scroll(function() {
        var body = document.body,
            html = document.documentElement;

        var height = Math.max( body.scrollHeight, body.offsetHeight,
                              html.clientHeight, html.scrollHeight, html.offsetHeight );
        var div = $(this);
        var scroll = 0;
        setTimeout(function() {
            scroll = div.scrollTop();
        }, 200);
        if (Math.round($(this).scrollTop()) == height - window.innerHeight){
            for(var i = 0; i < 3; i++){     // 3 strings * 5 photos each
                if(document.getElementById("checkBoxPane") != null && document.getElementById("checkBoxPane").checked){
                    var stringDiv = loadPhotos();
                    $(".sharedFeed").append(stringDiv);
                } else {  // update db (shared feed call))
                    var stringDiv = loadPhotos();
                    $(".feed").append(stringDiv);
                }
            }
        }
    });
    
    $(document).keypress( // prevents form from being submitted when enter is pressed
            function(event){
                if (event.which == '13') {

                    event.preventDefault();
                    var activeElement = document.activeElement;

                    if (activeElement.className == "ushare"){
                        event.preventDefault();
                        //		                alert('prevented');
                        var taggedUser = document.createElement("div");

                        var copyDiv = "<div id=\"username\">" + document.getElementById('ushare').value + "</div>" +
                            "<div class=\"uexit\" onclick=\"return deleteUser(\'{%=taggedUser%}\', event)\">x</div><br>" +
                            document.getElementById('ususers').innerHTML;

                        //add classes
                        taggedUser.setAttribute('id', "username");


                        taggedUser.innerHTML = "<div id=\"username\">" + document.getElementById('ushare').value + "</div>" +
                            "<div class=\"uexit\" onclick=\"return deleteUser(this.parentElement, event)\">x</div><br>" +
                            document.getElementById('ususers').innerHTML;

                        // update check muna if there's a user in the db before adding(?)
                        document.getElementById('ususers').append(taggedUser);
                        document.getElementById('ushare').value = "";
                    } else if (activeElement.id == "utags"){
                        //		                alert('hello');
                        document.getElementById('utags').value = "#" + document.getElementById('utags').value;
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/ /g, " #");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/##/g, "#");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/#&nbsp;&nbsp;#/g, "#");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/# #/g, "#");
                    } else if (activeElement.className == "captionTags") {
                        var ct = document.activeElement;
                        //		                alert(document.activeElement.innerHTML);
                        //		                alert(ct.text);
                        //		                alert(ct.value);
                        //		                ct.innerHTML = ct.innerHTML.replace(/&nbsp; &nbsp;/g, '');
                        //		                ct.innerHTML = ct.innerHTML.replace(/ /g, " #");
                        //		                ct.innerHTML = ct.innerHTML.replace(/ <br> /g, "");
                        //		                ct.innerHTML = ct.innerHTML.replace(/<br><br>/g, "");
                        //		                ct.innerHTML = ct.innerHTML.replace(/<br>/g, " #");
                        //		                ct.innerHTML = ct.innerHTML.replace(/##/g, "#");
                        //		                ct.innerHTML = ct.innerHTML.replace(/#&nbsp;#/g, "#");


                        if(ct.value.charAt(0) != "#" && ct.value.length != '0')
                            ct.value = "#" + ct.value + " #";

                        if(ct.value.charAt(ct.value.length - 1) != " " && ct.value.charAt(ct.value.length - 1) != "#" && ct.value.length != 0)
                            ct.value = ct.value + " #";
                    }

                }
            });
	});
</script>

<style>
#sidebar {
	position: fixed;
	z-index: 8;
	top: 100px;
	left: -230px;
	transition: all 0.5s ease-in;
}

#sidebar:hover {
	left: 30px;
	transition: all 0.5s ease-in;
}

#pulltab {
	position: relative;
	display: inline-block;
	border-radius: 100px;
	border-width: medium;
	border-color: white;
	border-style: solid;
	width: 60px;
	height: 60px;
	/*                background-color: white;*/
	background-image: url('media/user.png');
	background-size: cover;
	margin: 10px;
	top: 20px;
	box-shadow: 2px 2px 15px rgba(57, 57, 57, 0.53);
}

#info {
	display: inline-block;
	background-color: white;
	height: 300px;
	width: 200px;
	padding: 15px;
	border-radius: 10px;
	box-shadow: 2px 2px 15px rgba(57, 57, 57, 0.53);
}

#description {
	
}
/* The.slider-container - the box around the slider */
.slider-container {
	position: fixed;
	display: inline-block;
	border-radius: 100px;
	position: fixed;
	z-index: 8;
	right: 25px;
	top: 100px;
	width: 50px;
	height: 25px;
	background-color: grey;
	text-align: center;
	box-shadow: 2px 2px 2px rgba(57, 57, 57, 0.53);
}
/* Hide default HTML checkbox */
.slider-container input {
	display: none;
}
/* The slider */
.slider {
	position: initial;
	border-radius: 100px;
	width: 25px;
	height: 25px;
	background-color: white;
	transition: all 0.3s ease-in;
	cursor: pointer;
	-webkit-transition: .3s;
}

.slider:before {
	position: absolute;
	content: "";
	border-radius: 100px;
	width: 25px;
	height: 25px;
	left: 0px;
	background-color: white;
	-webkit-transition: .3s;
	transition: all 0.3s ease-in;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}
/* Rounded sliders */
.slider {
	border-radius: 34px;
}

.slider:before {
	border-radius: 50%;
}

#a1 {
	font-family: Roboto;
	font-size: 20px;
	color: darkgrey;
	position: relative;
	top: 100px;
	width: 100%;
	text-align: center;
}
</style>

<script>

</script>

<title>Profile | ${param.username}</title>
</head>
<body>
	
    <!-- Rounded.slider-container -->   
    <label class="slider-container">
        <input type="checkbox" id = "checkBoxPane">
        <span class="slider" id="slider"></span>
    </label>
    
    <!-- Pull out user photo that reveals username and short description  -->
    <div id = "sidebar">

        <div id = "info">
            <a id = "username">${param.username}</a>
            <p id = "description">${param.description}</p>
        </div>

        <div id = "pulltab"></div>

    </div>

    <div class = "searchbar">
        <input type = "search" id = "searchbox" placeholder="Search">
    </div>
        
        <div id = "navbar">
            <a href = "index.html" id = "title"> twine </a>
            
            <div class="links" id = "navBarLinks">
                <a class = "acc" id = "login">Log In</a>
                |
                <a class = "acc" id = "signup">Sign Up</a>
                <div id = "clickedNavBarLinks">
                </div>
            </div>
        </div>
    
    <div id="a1">Public Photos</div>

    <section class = "feed" id = "feed">
    </section>
    <section class = "sharedFeed" id = "sharedFeed">
    </section>
	
</body>
</html>