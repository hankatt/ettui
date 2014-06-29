jquery = document.createElement("script");
jquery.src = "https://code.jquery.com/jquery-2.1.1.min.js";
document.body.appendChild(jquery);

css = document.createElement("link");
css.href = "http://localhost:3000/bookmarklet.css";
css.type = "text/css";
css.rel = "stylesheet";
document.body.appendChild(css);

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
			jsonpScript.id = "noted-add-script";
			jsonpScript.src =  "//localhost:3000/add/quote/?" + jQuery.param(params);
			document.body.appendChild(jsonpScript);
		}

		/* Defines the look of the popup being created when you click the bookmarklet. */
		createAndAppendBookmarkletContainer();


		/* Define function that deals with JSONP callback */
		quoteCallback = function status(data) {
			/* Remove script so it doesnt lay around */
			$("#noted-add-script").remove();

			/* Deal with response */
			if(data && data.message) {
				if(data.action === "tags") {

					/* Check if quote was saved or not */
					$(".status-message").html(data.message);
					$(".sub-message").html(data.submessage);

					/* Add HTML semantics for the tags */
					$(".noted-bookmarklet").append("<div class='tag-container'></div>");
					$(".noted-bookmarklet").append("<input type='text' id='noted-new-tag'>");
					$(".noted-bookmarklet").append("<a href='#!' onclick='closeNoted()' id='noted-close-btn'>Close window</a>");
					$("#noted-new-tag").focus();

					/* Append tags to popup */
					for(i = 0; i < data.tags.length; i++)
						$(".tag-container").append(createElementWithClass("li", "noted-tag", data.tags[i].name));

					/* Save q.id for later access */
					session_data.qid = data.qid;

					$(".noted-tag").click(function() {

						$(this).addClass('selected');

						var params = {
							user_token: current_user_token,
							qid: session_data.qid,
							tag: $(this).text(),
							is_new: false,
							callback: "added"
						}

						/* Execute JSONP call using script tag. */
						jsonpScript = document.createElement("script");
						jsonpScript.id = "noted-add-script";
						jsonpScript.src =  "//localhost:3000/add/tag/?" + jQuery.param(params);
						document.body.appendChild(jsonpScript);
					});

					$("#noted-new-tag").keyup(function (e) {
					    if (e.keyCode == 13) {
							new_tag = $(this);

							tag_exists = false;
							$(".noted-tag").each(function() {
								if(new_tag.val() === $(this).text())
									tag_exists = true;
							});

							if(tag_exists) {
								$(".status-message").html("Tag already exist.");
								$(".sub-message").html("Try adding a new tag.");
								new_tag.val(''); //Reset input field
							} else {
								var params = {
									user_token: current_user_token,
									qid: session_data.qid,
									tag: new_tag.val(),
									is_new: true,
									callback: "added"
								}

								/* Execute JSONP call using script tag. */
								jsonpScript = document.createElement("script");
								jsonpScript.id = "noted-add-script";
								jsonpScript.src =  "//localhost:3000/add/tag/?" + jQuery.param(params);
								document.body.appendChild(jsonpScript);
							}
						}
					});
				}
			}
		};

		addQuoteResponse = document.createElement("script");
		addQuoteResponse.setAttribute("type", "text/javascript");
		addQuoteResponse.innerHTML = quoteCallback;
		document.body.appendChild(addQuoteResponse);

		tagCallback = function added(data) {
			/* Remove script so it doesnt lay around */
			$("#noted-add-script").remove();

			if(data && data.message) {
				console.log(data.tag);
				if(data.is_new === "true")
					$(".tag-container").append(createElementWithClass("li", "noted-tag selected", data.tag));
				$(".status-message").html("#" +data.tag +" " +data.message);
				$(".sub-message").html(data.submessage);
				$("#noted-new-tag").val('');
			}
		};

		/* addTagResponse */
		addTagResponse = document.createElement("script");
		addTagResponse.setAttribute("type", "text/javascript");
		addTagResponse.innerHTML = tagCallback;
		document.body.appendChild(addTagResponse);
	});
};

createElementWithClass = function(element_type, element_class, element_text) {
	elem = document.createElement(element_type);
	elem.className = elem.className + element_class;
	elem.innerText = element_text;
	return elem.outerHTML;
}

createAndAppendBookmarkletContainer = function() {
	popup = document.createElement("div");
	popup.className = popup.className + "noted-bookmarklet";
	$(popup).append('<h1 class="status-message">Saving...</h1>');
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
}