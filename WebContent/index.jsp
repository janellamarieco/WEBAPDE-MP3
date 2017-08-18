<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Link to FontAwesome -->
<link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet" />
<meta name="viewport" content="width=device-width" />

<!-- JavaScript -->
<script src="jquery-3.2.1.min.js"></script>

<script>
var loaded = 0; // loaded photos
var loggedInUser; // logged in user

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

function postPhoto(){
	var pin          = document.createElement("div");
	var groove       = document.createElement("div");
	var metal        = document.createElement("div");
    var polaroid     = document.createElement("div");
    var thumbnail    = document.createElement("div");

    var modal        = document.createElement("div");
    var close        = document.createElement("span");
    var photo        = document.createElement("div");
    var caption      = document.createElement("div");

    var tag          = document.createElement("div");
    var editTags     = document.createElement("div");
    var divider      = document.createElement("div");
    var exitEditTags = document.createElement("span");
	var inputTagUser = document.createElement("input");
    var taggedUsers  = document.createElement("div");

    var ct = document.createElement("div");

    var navbar       = document.getElementById('navbar');
    
  	//add classes
    $(pin).addClass("pin");
    $(groove).addClass("groove");
    $(metal).addClass("metal");
    $(polaroid).addClass("polaroid");
    $(thumbnail).addClass("thumbnail");


    $(modal).addClass("modal");
    $(close).addClass("modal-close");
    $(photo).addClass("photo");
    $(caption).addClass("caption");

    $(tag).addClass("tag-overlay");
    $(divider).addClass("divider");
    $(editTags).addClass('edittags');
    $(exitEditTags).addClass("exit");
    $(taggedUsers).addClass('taggedusers');
    $(inputTagUser).addClass('taguser');
    $(ct).addClass('captionTags');
    $(ct).addClass('custom.delicious');
    
    var edit = document.createElement("div");
    $(edit).addClass("edit");

    tag.setAttribute('id', "tag");
    ct.setAttribute('id', "captionTags");

    inputTagUser.setAttribute('type', 'text');
    inputTagUser.setAttribute('placeholder', 'Enter username');
    
    
    var title = document.createElement("p");
    $(title).addClass('captionTitle');
    $(title).text(data.title);

    var puser = document.createElement("p");
    $(puser).addClass('puser');
    var desc = document.createElement("p");
    $(desc).addClass('captionDescription');
    
    $(caption).append(edit);
    $(caption).append(title);
    $(caption).append(puser);
    $(caption).append(desc);
    $(caption).append(ct);

    //assemble
    $(photo).prepend('<img id="theImg" src="' + "https" + '${photo.photo_id}' + '.png" />');
    $(photo).append(tag);
    $(modal).append(close);
    $(modal).append(photo);
    $(modal).append(caption);

    $(thumbnail).prepend('<img id="theImg" src="' + "https" + data.thumbnailUrl.substring(4   , data.thumbnailUrl.length)  + '.png" />');
    $(pin).append(groove);
    $(groove).append(metal);
    $(polaroid).append(thumbnail);
}

function changeNavBar() {
      var navBar = document.getElementById('navbar');
      var loggedInUser   =  getCookie("loggedInUser").substring(getCookie("loggedInUser").indexOf("="), getCookie("loggedInUser").length);
      navBar.innerHTML = "<div id = \"navbar\">" 
        				+ "<a href = \"home\" id = \"title\"> twine </a>" 
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
    
    $(document).on('click', '.polaroid', function(event){
    	var id = $(this).attr('id');

    	$('.modal#'+id).style.display="flex";
    	
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
                    	window.location.href = "home";
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

        window.location.href = "home";
    });
    
    /* user clicked upload button */
    /* $("#uploadButton").click(function(event){

        // update db (save images)
        /* var elm = document.getElementById('file'),
        	img = elm.files[0],
        	fileName = img.name,
        	fileSize = img.size;
        
        var read = new FileReader(), binary, base64;
        reader.addEventList('loadend', function(){
        	binary = reader.result;
        	base64 = btoa(binary);
        }, false);
        
        reader.readAsBinary(img); */
        

        alert(value);
    }); */
    
    $("#upload").click(function(event){
        event.stopPropagation();
        var x = document.getElementById('clickedNavBarLinks');
        x.style.display = 'block';

        x.innerHTML = " <form action=\"uploadPhoto\" method=\"post\" enctype=\"multipart/form-data\"" +
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
        
        document.getElementsByClassName('photo').addEventListener('mouseover', function(){
            tag.style.display = "block";
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
        
    $("#checkBoxPane").click(function(event){

        if(document.getElementById("checkBoxPane").checked){

            var feed = document.getElementById('feed');
            var sharedFeed = document.getElementById('sharedFeed');

            feedScrollTop =  document.body.scrollTop;
            document.getElementById('a1').innerHTML = "Shared Photos";
            //$('body, html').animate({ scrollLeft: $(this).width }, 700);

            feed.style.display = "none";
            sharedFeed.style.display = "block";
            document.body.scrollTop  = sharedFeedScrollTop;
        } else {
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
                        document.getElementById('utags').value = "#" + document.getElementById('utags').value;
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/ /g, " #");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/##/g, "#");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/#&nbsp;&nbsp;#/g, "#");
                        document.getElementById('utags').value = document.getElementById('utags').value.replace(/# #/g, "#");
                    } else if (activeElement.className == "captionTags") {
                        var ct = document.activeElement;
                    

                        if(ct.value.charAt(0) != "#" && ct.value.length != '0')
                            ct.value = "#" + ct.value + " #";

                        if(ct.value.charAt(ct.value.length - 1) != " " && ct.value.charAt(ct.value.length - 1) != "#" && ct.value.length != 0)
                            ct.value = ct.value + " #";
                    }

                }
            });
	});
</script>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link rel="stylesheet" type="text/css" href="style.css">

<title>Twine | Home</title>
</head>
<body>
	<div class="searchbar">
		<input type="search" id="searchbox" placeholder="Search">
	</div>

	<div id="navbar">
		<a href="home" id="title"> twine </a>

		<div class="links" id="navBarLinks">
			<a class="acc" id="login">Log In</a> | <a class="acc" id="signup">Sign Up</a>
			<div id="clickedNavBarLinks">
			</div>
		</div>
	</div>

	<section class="feed" id="feed">
		<div class="string">
			<c:forEach items="${publicPhotos}" var="photo" begin = "0" end = "4">
				<div class = "pin">
					<div class = "groove">
						<div class = "metal">
						</div>
					</div>
				</div>
							
				<div class = "polaroid" id="${photo.photo_id}">
					<div class = "thumnbail"> 
						<img id="theImg" width="180px" height="170px" src="${photo.url}" />
					</div>
					
					<p>
						<c:choose>
							<c:when test = "${photo.privacy == 'shared'}">
								Shared
							</c:when>
							<c:otherwise>
								Public
							</c:otherwise>	
						</c:choose>				
					</p>
			</div>		
			
			<div class="modal" id="${photo.photo_id}">
				<span class="modal-close">x</span>
				<div class="photo">
					<img id="theImg" src="${photo.url}" />
				</div>
				<div class="caption">
					<p class="captionTitle">${photo.title}</p>
	
					<p class="pUser">${photo.user.username}</p>
	
					<div class="tag" id="tag">
						<a class="username" href=""></a>
					</div>
	
					<p class="captionDescription">${photo.description}</p>
	
					<p class="captionTags"></p>
	
					<div class="edit">
						<i class="fa fa-pencil-square-o" aria-hidden="true"></i>
					</div>
				</div>
	
						<!-- <div class = "tag-overlay">
							<i class="fa fa-tags" aria-hidden="true"></i>
							<p class = "tagged">Tagged: </p>
							<div class = "editTags">
							<input class = "inputTagUser" type="text" placeholder="Enter username"></input>
							<span class = "exitEditTags"></span>
							<div class = "divider"></div>
							<div class = "taggedUsers"></div>-->
			</div>
			</c:forEach> 		
			
		</div>
	</section>

</body>
</html>