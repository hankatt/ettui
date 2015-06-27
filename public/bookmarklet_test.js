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
jquery.src = "http://code.jquery.com/jquery-2.1.1.min.js";
document.body.appendChild(jquery);

css = document.createElement("link");
css.className = "noted-temporary-function-tbr";
css.href = "http://192.168.1.65:3000/bookmarklet_test.css";
css.type = "text/css";
css.rel = "stylesheet";
document.body.appendChild(css);

jquery.onload = function() {
	popup = "", jsonpScript = "";
	session_data = {};

	$(function() {
		/* Defines the look of the popup being created when you click the bookmarklet. */
		createAndAppendBookmarkletContainer();
		notedBookmarklet = $(".noted-bookmarklet");

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

		/* Append existing tags to popup */
		
		for(i = 0; i < 6; i++) {
			$(".tag-container").append(createElementWithClass("li", "noted-tag", "test"));
		}

		setTimeout(function() {
			/* Remove loading spinner */
			$(".noted-spinner").remove();

			/* Output callback status messages */
			$(".status-message").html("Quote saved.");
			$(".sub-message").html("Add some tags below.");

			notedBookmarklet.css('max-height', $(this).height() + ncc.height());
			ncc.show().animate({
				opacity: 1
			}, 670, function() {
				$("#noted-new-tag").focus();
			});
			$(".noted-logo, .noted-close").addClass('visible');
		}, 2000);

		$(".noted-tag").click(function() {
			$(this).addClass('selected');
		});

		/* Define function that deals with JSONP callback */
		//quoteCallback = function status(data) {

			/* Deal with response */
			if(true) {
				if(true) {

					$("#noted-new-tag").keyup(function (e) {
					    if (e.keyCode == 13) {
							new_tag = $(this);
							$(".tag-container").append(createElementWithClass("li", "noted-tag selected", new_tag.val()));
						}
					});

					$("#noted-new-tag-submit").on('click', function(e) {
						new_tag = $(this).siblings('#noted-new-tag');
						$(".tag-container").append(createElementWithClass("li", "noted-tag selected", new_tag.val()));
					});
				}
			}
		//};

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

closeNoted = function() {
	$(".noted-bookmarklet").remove();
	$(".noted-temporary-function-tbr").remove();
}
