// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function getSession() {
  token_request = new XMLHttpRequest();
  var url = "http://localhost:3000/quotes/get_token";
  session_id = false;

  token_request.open("GET", url, true);
  token_request.onreadystatechange = sessionState;
  token_request.send(null);
}

function sessionState() {
  //console.log("request.readyState: " +request.readyState);
  if (token_request.readyState == 4) {
    console.log(token_request.responseText);
  }
}

function getXML() {
	request = new XMLHttpRequest();
    var url = "http://localhost:3000/quotes/add?text=Hello&source=http";
    request.open("GET", url, true);
    request.onreadystatechange = updateState;
    request.send(null);
}

function updateState() {
	//console.log("request.readyState: " +request.readyState);
	if (request.readyState == 4) {
		console.log("# # # # # # # # # \n\nReponse: " +request.responseText +"\n\n");
		console.log("# # # # # # # # # \n" +request.getAllResponseHeaders() +"# # # # # # # # # \n");
	}
}

function done() {
	alert("Done.");
}
