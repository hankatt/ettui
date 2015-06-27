bookmarklet_server_host = "localhost:3000"

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
css.href = "//" +bookmarklet_server_host +"/bookmarklet.css";
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
			close_bookmarklet();
			return false;
		} else {

			/*
		
				COLLECTING DATA AND SENDING QUOTE TO SERVER

			*/

			var params = {
				user_token: current_user_token,
				text: encodeURIComponent(document.getSelection().toString()),
				url: encodeURIComponent(document.location.href.toString()),
				favicon: favicon(),
				callback: "success"
			}

			/* Execute JSONP call using script tag. */
			jsonpScript = document.createElement("script");
			jsonpScript.className = jsonpScript.className + "noted-temporary-function-tbr";
			jsonpScript.src =  "//" +bookmarklet_server_host +"/add/quote/?" + jQuery.param(params);
			document.body.appendChild(jsonpScript);
		}

		/* Defines the look of the popup being created when you click the bookmarklet. 
			
			<div class="noted-bookmarklet">
				<div class="noted-spinner"></div>
				<a href="https://notedapp.herokuapp.com" target="_blank"></div class="noted-logo"></div></a>
				<a href="#!" onclick="close_bookmarklet()"><div class="noted-close"></div></a>
				<h1 class="status-message"></h1>
				<h1 class="sub-message"></h1>
			</div>

		*/
		
		popup = document.createElement("div");
		popup.className = popup.className + "noted-bookmarklet";
		$(popup).html('<div class="noted-spinner"></div><a href="https://' +bookmarklet_server_host +'" target="_blank"><div class="noted-logo"></div></a><a href="#!" onclick="close_bookmarklet()"><div class="noted-close"></div></a><h1 class="status-message"></h1><h1 class="sub-message"></h1>');
		document.body.appendChild(popup);
		bookmarklet = $(".noted-bookmarklet");


		/*
		
			WHEN A QUOTE HAS BEEN ADDED

		*/

		add_quote_callback = function success(data) { // CALLBACK: success()
			/* Deal with response */
			if(data && data.message) {

				cb_data = data;
				session_data.qid = data.quote.id; // Save q.id for later access

				/* Add HTML semantics for the tags
					
					<div class='noted-content-container'>
						<div class='tag-container'></div>
						<div class='add-tag-container'>
							<input type='text' id='noted-new-tag' placeholder='Type a new tag and press enter'>
							<input type='submit' id='noted-new-tag-submit' value='Add'>
						</div>
						<a href='#!' onclick='close_bookmarklet()' id='noted-close-btn'>Close window</a>
					</div>
				
				*/

				bookmarklet.append("<div class='noted-content-container'></div>");
				noted_content_container = $(".noted-content-container");
				noted_content_container.append("<div class='tag-container'></div>");
				noted_content_container.append("<div class='add-tag-container'></div>");
				noted_content_container.append("<a href='#!' onclick='close_bookmarklet()' id='noted-close-btn'>Close window</a>");

				// Add container and inputs for adding a new tag
				add_tag_container = $(".noted-content-container .add-tag-container");
				add_tag_container.append("<input type='text' id='noted-new-tag' placeholder='Type a new tag and press enter'>");
				add_tag_container.append("<input type='submit' id='noted-new-tag-submit' value='Add'>");
				$("#noted-new-tag").focus();

				/* Append tags to popup

					<div class='tag-container'>
						...
						<li class="noted-tag tid-#">data.tags[i].name</li>
						...
					</div>

				*/

				for(i = 0; i < data.tags.length; i++) {
					tag_class = "noted-tag tid-" +data.tags[i].id;
					$(".tag-container").append(li_with_class_and_text(tag_class, data.tags[i].name));
				}


				/* Give the data 2s to load and then show the quote. */
				setTimeout(function() {
					/* Remove loading spinner */
					$(".noted-spinner").remove();

					/* Output callback status messages */
					$(".status-message").html(data.message);
					$(".sub-message").html(data.submessage);

					noted_content_container.show().animate({
						opacity: 1
					}, 670, function() {
						$("#noted-new-tag").focus();
					});

					$(".noted-logo, .noted-close").addClass('visible');
				}, 2000);


				/* Sending the tag to the server
					
					1. Clicking <li class="noted-tag...">{tag name}</li>
					2. Pressing Enter (13) on <input type='text' id='noted-new-tag'..>
					3. Clicking on <input type='submit' id='noted-new-tag-submit' value='Add'>

				*/

				$(".noted-tag").click(function() {
					tag = $(this);
					tag.addClass('selected');
					tag_name = tag.text();

					/* Execute JSONP call using script tag. */
					add_tag_remotely({
						user_token: current_user_token,
						quote_id: session_data.qid,
						tag: tag_name,
						callback: "added"
					});

				});

				$("#noted-new-tag").keyup(function (e) {
				    if (e.keyCode == 13) {
						tag = $(this);
						tag_name = tag.val();

						/* Execute JSONP call using script tag. */
						add_tag_remotely({
							user_token: current_user_token,
							quote_id: session_data.qid,
							tag: tag_name,
							callback: "added"
						});
					}
				});

				$("#noted-new-tag-submit").on('click', function(e) {
					tag = $(this).siblings('#noted-new-tag');
					tag_name = tag.val();

					/* Execute JSONP call using script tag. */
					add_tag_remotely({
						user_token: current_user_token,
						quote_id: session_data.qid,
						tag: tag_name,
						callback: "added"
					});
				});
			}
		};

		add_quote_callback_failed = function failed(data) { // CALLBACK: failed()

			/* Deal with response */
			if(data && data.message) {

				session_data.qid = data.quote.id; // Save q.id for later access

				/* Give the data 2s to load and then show the quote. */
				setTimeout(function() {
					/* Remove loading spinner */
					$(".noted-spinner").remove();

					/* Output callback status messages */
					$(".status-message").html(data.message);
					$(".sub-message").html(data.submessage);

					$(".noted-logo, .noted-close").addClass('visible');
				}, 2000);
			}
		};

		/*
		
		<script class="noted-temporary-function-tbr" type="text/javascript">
			...add_quote_callback()...
		</script>

		*/

		add_quote_script = document.createElement("script");
		add_quote_script.setAttribute("type", "text/javascript");
		add_quote_script.className = "noted-temporary-function-tbr";
		add_quote_script.innerHTML = add_quote_callback + add_quote_callback_failed;
		document.body.appendChild(add_quote_script);

		/*
		
			WHEN A TAG HAS BEEN ADDED

		*/

		add_tag_callback = function added(data) {  // CALLBACK: added()

			if(data && data.message) {

				// Update messages
				$(".status-message").html("#" +data.tag.name +" " +data.message);
				$(".sub-message").html(data.submessage);

				if(data.add === true) {
					// New Tag data
					tag_class = "selected noted-tag tid-" +data.tag.id;
					tag_name = data.tag.name;

					// Add new Tag to the tag container
					$(".tag-container").append(li_with_class_and_text(tag_class, tag_name));

				} else if(data.update === true) {
					// Mark Tag as selected
					$(".tag-container > .tid-" +data.tag.id).addClass('selected');
				}

				// Reset input field
				$("#noted-new-tag").val('');
			}
		};

		/*
		
		<script class="noted-temporary-function-tbr" type="text/javascript">
			...add_tag_callback()...
		</script>

		*/

		tag_callback_script = document.createElement("script");
		tag_callback_script.className = "noted-temporary-function-tbr";
		tag_callback_script.setAttribute("type", "text/javascript");
		tag_callback_script.innerHTML = add_tag_callback;
		document.body.appendChild(tag_callback_script);
	});
};

add_tag_remotely = function(params) {
	jsonpScript = document.createElement("script");
	jsonpScript.className = "noted-temporary-function-tbr";
	jsonpScript.src =  "//" +bookmarklet_server_host +"/add/tag_remotely/?" + jQuery.param(params);
	document.body.appendChild(jsonpScript);
}

li_with_class_and_text = function(element_class, element_text) {
	elem = document.createElement("li");
	elem.className = elem.className + element_class;
	elem.innerHTML = element_text;
	return elem.outerHTML;
}

favicon = function() {
	rel = "icon";
	if(document.querySelectorAll("link[rel~=" +rel +"]").length > 0)
		return encodeURIComponent(document.querySelectorAll("link[rel~=" +rel +"]")[0].href);
	else
		return encodeURIComponent("http://" +document.location.hostname +"/favicon.ico");
}

close_bookmarklet = function() {
	$(".noted-bookmarklet").remove();
	$(".noted-temporary-function-tbr").remove();
}
