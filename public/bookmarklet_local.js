javascript:(function(){
	well = function() {
		try {
		  if(!document.body) {
		    throw(0);
		   }

		  if(document.getSelection().toString() === "") {
		    alert("Empty selection.");
		    throw(0);
		  } else {
		    
		    text      = encodeURIComponent(document.getSelection().toString());
		    url       = encodeURIComponent(document.location.href.toString());
		    token     = current_user_token;
		    rel       = "icon";
		    favicon   = function() {
		                if(document.querySelectorAll("link[rel~=" +rel +"]").length > 0)
		                  return encodeURIComponent(document.querySelectorAll("link[rel~=" +rel +"]")[0].href);
		                else
		                  return encodeURIComponent("http://" +document.location.hostname +"/favicon.ico");
		              };

		    query     = "//localhost:3000/quotes/add?user_token=" +token +"&text=";

		    script    = document.createElement("script");
		    script.src  = query + text + "&url=" + url + "&favicon=" + favicon() + "&callback=status";
		  }

		  /* TAKES CARE OF JSONP RESPONSE */
		  jsonp = document.createElement("script");
		  jsonp.setAttribute("type", "text/javascript");

		  callback = function status(data) {
		    if(data && data.message) {
		      headline.innerText = data.message;
		      popup.innerHTML = headline.outerHTML;
		      counter = 0;
		      interval = setInterval(function() {
		        counter += 25;
		        wait = 350;
		        if(counter > wait) {
		          value = counter - wait;
		          popup.style.opacity = popup.style.opacity - (value/1000);
		          document.body.removeChild(popup);
		          document.body.appendChild(popup);
		          if(counter === 1500) {
		            clearInterval(interval);
		            counter = 0;
		            document.body.removeChild(popup);
		          }
		        }
		      }, 50);
		    }
		  };

		  jsonp.innerHTML = callback;
		  document.body.appendChild(jsonp);
		  
		  /* CREATES POPUP */
		  headline = document.createElement("h1");
		  headline.id = "well-title";
		  headline.style.textAlign = "center";
		  headline.style.fontSize = "1em";
		  headline.innerText = "Saving..";

		  popup = document.createElement("div");
		  popup.style.width = "175px";
		  popup.style.padding = "25px";
		  popup.style.backgroundColor = "#fff";
		  popup.style.zIndex = "20000";
		  popup.style.position = "fixed";
		  popup.style.top = "0";
		  popup.style.opacity = "1";
		  popup.innerHTML = headline.outerHTML;
		  document.body.appendChild(popup);

		  /* EXECUTE SCRIPT */
		  document.body.appendChild(script);

		} catch(e) {
		  alert("Please wait until the page has loaded.");
		}
	};

	if(/Firefox/.test(navigator.userAgent)) {
		setTimeout(well,0);
	} else {
		well();
}})();