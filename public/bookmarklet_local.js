WebFontConfig = {
	google: { 
		families: [ 'Open+Sans:300,600:latin' ]
	}
};

(function() {
	var wf = document.createElement('script');
	wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
	  '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
	wf.type = 'text/javascript';
	wf.async = 'true';
	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(wf, s);
})();

jquery = document.createElement("script");
jquery.className = "noted-function";
jquery.src = "https://code.jquery.com/jquery-2.1.1.min.js";
document.body.appendChild(jquery);

css = document.createElement("link");
css.className = "noted-temporary-function-tbr";
css.href = "http://192.168.1.65:3000/bookmarklet.css";
css.type = "text/css";
css.rel = "stylesheet";
try {
	document.body.appendChild(css);
} catch(e) {
	console.log(e);
	err__ = e;
	alert("This page does not allow noted to load its stylesheet.")
}

jquery.onload = function() {
	popup = "", jsonpScript = "";
	session_data = {};

	$(function() {
		if(document.getSelection().toString() === "") {
			alert("Empty selection.");
		} else {
			var params = {
				user_token: current_user_token,
				text: encodeURIComponent(document.getSelection().toString()),
				url: encodeURIComponent(document.location.href.toString()),
				favicon: getFavicon(),
				callback: "status"
			}

			/* Execute JSONP call using script tag. */
			jsonpScript = document.createElement("script");
			jsonpScript.className = jsonpScript.className + "noted-temporary-function-tbr";
			jsonpScript.src =  "//192.168.1.65:3000/add/quote/?" + jQuery.param(params);
			document.body.appendChild(jsonpScript);
		}

		/* Defines the look of the popup being created when you click the bookmarklet. */
		createAndAppendBookmarkletContainer();
		notedBookmarklet = $(".noted-bookmarklet");


		/* Define function that deals with JSONP callback */
		quoteCallback = function status(data) {

			/* Deal with response */
			if(data && data.message) {
				if(data.action === "tags") {

					/* Add HTML semantics for the tags */
					notedBookmarklet.append("<div class='noted-content-container'></div>");
					ncc = $(".noted-content-container");
					ncc.append("<div class='tag-container'></div>");
					ncc.append("<div class='add-tag-container'></div>");
					ncc.append("<a href='#!' onclick='closeNoted()' id='noted-close-btn'>Close window</a>");

					// Add container and inputs for adding a new tag
					atc = $(".noted-content-container .add-tag-container");
					atc.append("<input type='text' id='noted-new-tag' placeholder='Type a new tag and press enter'>");
					atc.append("<input type='submit' id='noted-new-tag-submit' value='Add'>");
					$("#noted-new-tag").focus();

					/* Append tags to popup */
					for(i = 0; i < data.tags.length; i++) {
						$(".tag-container").append(createElementWithClass("li", "noted-tag tid-" +data.tags[i].id, data.tags[i].name));
					}

					setTimeout(function() {
						/* Remove loading spinner */
						$(".noted-spinner").remove();

						/* Output callback status messages */
						$(".status-message").html(data.message);
						$(".sub-message").html(data.submessage);

						notedBookmarklet.css('max-height', $(this).height() + ncc.height());
						ncc.show().animate({
							opacity: 1
						}, 670, function() {
							$("#noted-new-tag").focus();
						});

						$(".noted-logo, .noted-close").addClass('visible');

					}, 2000);

					/* Save q.id for later access */
					session_data.qid = data.qid;

					$(".noted-tag").click(function() {

						$(this).addClass('selected');

						var params = {
							user_token: current_user_token,
							qid: session_data.qid,
							tag: $(this).text(),
							callback: "added"
						}

						/* Execute JSONP call using script tag. */
						jsonpScript = document.createElement("script");
						jsonpScript.className = "noted-temporary-function-tbr";
						jsonpScript.src =  "//192.168.1.65:3000/add/tag_remotely/?" + jQuery.param(params);
						document.body.appendChild(jsonpScript);
					});

					$("#noted-new-tag").keyup(function (e) {
					    if (e.keyCode == 13) {
							new_tag = $(this);

							var params = {
								user_token: current_user_token,
								qid: session_data.qid,
								tag: new_tag.val(),
								callback: "added"
							}

							/* Execute JSONP call using script tag. */
							jsonpScript = document.createElement("script");
							jsonpScript.className = "noted-temporary-function-tbr";
							jsonpScript.src =  "//192.168.1.65:3000/add/tag_remotely/?" + jQuery.param(params);
							document.body.appendChild(jsonpScript);
						}
					});

					$("#noted-new-tag-submit").on('click', function(e) {
						new_tag = $(this).siblings('#noted-new-tag');
						console.log("new tag name:");
						console.log(new_tag.val());
						var params = {
							user_token: current_user_token,
							qid: session_data.qid,
							tag: new_tag.val(),
							callback: "added"
						}

						/* Execute JSONP call using script tag. */
						jsonpScript = document.createElement("script");
						jsonpScript.className = "noted-temporary-function-tbr";
						jsonpScript.src =  "//192.168.1.65:3000/add/tag_remotely/?" + jQuery.param(params);
						document.body.appendChild(jsonpScript);
					});
				}
			}
		};

		addQuoteResponse = document.createElement("script");
		addQuoteResponse.setAttribute("type", "text/javascript");
		addQuoteResponse.className = "noted-temporary-function-tbr";
		addQuoteResponse.innerHTML = quoteCallback;
		document.body.appendChild(addQuoteResponse);

		tagCallback = function added(data) {

			if(data && data.message) {
				$(".status-message").html("#" +data.tag.name +" " +data.message);
				$(".sub-message").html(data.submessage);

				if(data.add === true)
					$(".tag-container").append(createElementWithClass("li", "noted-tag selected tid-" +data.tag.id, data.tag.name));
				
				if(data.update === true)
					$(".tag-container > .tid-" +data.tag.id).addClass('selected');
					
				// Reset input field
				$("#noted-new-tag").val('');
			}
		};

		/* addTagResponse */
		addTagResponse = document.createElement("script");
		addTagResponse.className = "noted-temporary-function-tbr";
		addTagResponse.setAttribute("type", "text/javascript");
		addTagResponse.innerHTML = tagCallback;
		document.body.appendChild(addTagResponse);
	});
};

createElementWithClass = function(element_type, element_class, element_text) {
	elem = document.createElement(element_type);
	elem.className = elem.className + element_class;
	elem.innerHTML = element_text;
	return elem.outerHTML;
}

createAndAppendBookmarkletContainer = function() {
	popup = document.createElement("div");
	popup.className = popup.className + "noted-bookmarklet";
	$(popup).append('<div class="noted-spinner"></div>');
	$(popup).append('<a href="https://notedapp.herokuapp.com" target="_blank"><div class="noted-logo"></div></a>');
	$(popup).append('<a href="#!" onclick="closeNoted()"><div class="noted-close"></div></a>');
	$(popup).append('<h1 class="status-message"></h1>');
	$(popup).append('<h1 class="sub-message"></h1>');
	document.body.appendChild(popup);
}

getFavicon = function() {
	rel = "icon";
	if(document.querySelectorAll("link[rel~=" +rel +"]").length > 0)
		return encodeURIComponent(document.querySelectorAll("link[rel~=" +rel +"]")[0].href);
	else
		return encodeURIComponent("http://" +document.location.hostname +"/favicon.ico");
};

closeNoted = function() {
	$(".noted-bookmarklet").remove();
	$(".noted-temporary-function-tbr").remove();
}