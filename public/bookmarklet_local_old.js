/*

      Bookmarklet Structure
      Updated 20150712


      1. Supporting assets
        1.1 Include WebFonts
        1.2 Include jQuery
        1.3 Include Ettúi CSS
      2. Save quote & define with callbacks
        2.1 Gather quote data and execute Script element injection
        2.2 Define Quote callbacks
          2.2.1 Success
          2.2.2 Failed
        2.3 Define Tag callbacks
          2.3.1 Success
      3. Supporting functions
        3.1 addTag Script element injection
        3.2 getFaviconURL attempts to figure out the sites favicon URL
        3.3 Closes and removes the bookmarklet window and support code


*/

bookmarklet_server_host = "localhost:3000"

/*


    1.1 Include WebFonts


*/
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

/*


    1.2 Include jQuery


*/
jquery = document.createElement("script");
jquery.className = "noted-temporary-function-tbr";
jquery.src = "http://code.jquery.com/jquery-2.1.1.min.js";
document.body.appendChild(jquery);

/*


    1.3 Include Ettúi Stylesheet


*/
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

// When jQuery has been loaded, start processing the quote
jquery.onload = function() {
  popup = "", jsonpScript = "";
  session_data = {};

   /*


      2.1 Gather Quote data


  */
  $(function() {

    if(document.getSelection().toString() === "") {
      alert("Ettúi did not find any selected text.");
      closeBookmarkletWindow();
      return false;
    } else {
      var params = {
        user_token: current_user_token,
        text: encodeURIComponent(document.getSelection().toString()),
        url: encodeURIComponent(document.location.href.toString()),
        favicon: getFaviconURL(),
        callback: "success"
      }

      // Use Script element injection to send the quote to the Ettúi server
      jsonpScript = document.createElement("script");
      jsonpScript.className = jsonpScript.className + "noted-temporary-function-tbr";
      jsonpScript.src =  "//" +bookmarklet_server_host +"/add/quote/?" + jQuery.param(params);
      document.body.appendChild(jsonpScript);
    }

    /*

      Defines the look of the popup being created when you click the bookmarklet. 
      
      <div class="noted-bookmarklet">
        <div class="noted-spinner"></div>
        <a href="https://localhost:3000" target="_blank"></div class="noted-logo"></div></a>
        <a href="#!" onclick="closeBookmarkletWindow()"><div class="noted-close"></div></a>
        <h1 class="status-message"></h1>
        <h1 class="sub-message"></h1>
      </div>

    */ 

    popup = document.createElement("div");
    popup.className = popup.className + "noted-bookmarklet";
    $(popup).html('<div class="noted-spinner"></div><h1 class="status-message"></h1><h1 class="sub-message"></h1>');
    document.body.appendChild(popup);
    bookmarklet = $(".noted-bookmarklet");
    /*


        2.2.1 Define Quote success(...) callback


    */
    quote_callback__added = function success(data) {
      if(data && data.message) {

        session_data.qid = data.quote.id; // Save q.id for later access

        /* Add HTML semantics for the tags
          
          <div class='noted-content-container'>
            <div class='tag-container'></div>
            <div class='add-tag-container'>
              <input type='text' id='noted-new-tag' placeholder='Type a new tag and press enter'>
              <input type='submit' id='noted-new-tag-submit' value='Add tag'>
            </div>
            <a href='#!' onclick='closeBookmarkletWindow()' id='noted-close-btn'>Close window</a>
          </div>
        
        */
        bookmarklet.append("<div class='noted-content-container'></div>");
        noted_content_container = $(".noted-content-container");
        noted_content_container.append("<div class='tag-container'></div>");
        noted_content_container.append("<div class='add-tag-container'></div>");
        noted_content_container.append("<a href='#!' onclick='closeBookmarkletWindow()' id='noted-close-btn'>Close window</a>");

        // Add container and inputs for adding a new tag
        add_tag_container = $(".noted-content-container .add-tag-container");
        add_tag_container.append("<input type='text' id='noted-new-tag' placeholder='Type a new tag and press enter'>");
        add_tag_container.append("<input type='submit' id='noted-new-tag-submit' value='Add tag'>");
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
          tag_name = data.tags[i].name;
          tag_list_item = "<li class='" +tag_class +"'>" +tag_name +"</li>";
          tag_container = $(".tag-container");
          tag_container.append(tag_list_item);
        }

        setTimeout(function() {
          $(".noted-spinner").remove();
          $(".status-message").html(data.message);
          $(".sub-message").html(data.submessage);

          noted_content_container.show().animate({
            opacity: 1
          }, 670, function() {
            $("#noted-new-tag").focus();
          });

          $(".noted-logo, .noted-close").addClass('visible');
        }, 1000);


        /* 

          Sending the tag to the server
          
          1. Clicking <li class="noted-tag...">{tag name}</li>
          2. Pressing Enter (13) on <input type='text' id='noted-new-tag'..>
          3. Clicking on <input type='submit' id='noted-new-tag-submit' value='Add'>

        */
        $(".noted-tag").click(function() {
          tag = $(this);
          tag.addClass('selected');
          tag_name = tag.text();

          addTag({
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

            addTag({
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

          addTag({
            user_token: current_user_token,
            quote_id: session_data.qid,
            tag: tag_name,
            callback: "added"
          });
        });
      }
    };


    /*


        2.2.2 Define Quote failed(...) callback


    */
    quote_callback__failed = function failed(data) {
      if(data && data.message) {
        session_data.qid = data.quote.id; // Save q.id for later access

        setTimeout(function() {
          $(".noted-spinner").remove();
          $(".status-message").html(data.message);
          $(".sub-message").html(data.submessage);
          $(".noted-logo, .noted-close").addClass('visible');
        }, 1000);
      }
    };

    /*
    
    <script class="noted-temporary-function-tbr" type="text/javascript">
      ...quote_callback__added()...
    </script>

    */
    quote_callback__script = document.createElement("script");
    quote_callback__script.setAttribute("type", "text/javascript");
    quote_callback__script.className = "noted-temporary-function-tbr";
    quote_callback__script.innerHTML = quote_callback__added + quote_callback__failed;
    document.body.appendChild(quote_callback__script);

    /*


        2.3.1 Define Tag success(...) callback


    */
    tag_callback__added = function added(data) {
      if(data && data.message) {
        $(".status-message").html(data.message);
        $(".sub-message").html("#" +data.tag.name +" " +data.submessage);

        if(data.add === true) { // The tag is new, so add it to the list
          tag_class = "selected noted-tag tid-" +data.tag.id;
          tag_name = data.tag.name;
          tag_list_item = "<li class='" +tag_class +"'>" +tag_name +"</li>";
          tag_container = $(".tag-container");
          tag_container.append(tag_list_item);
        } else if(data.update === true) { // The tag already exists, so only highlight it in the list
          $(".tag-container > .tid-" +data.tag.id).addClass('selected');
        }

        // Reset input field
        $("#noted-new-tag").val('');
      }
    };

    /*
    
    <script class="noted-temporary-function-tbr" type="text/javascript">
      ...tag_callback__added()...
    </script>

    */
    tag_callback__script = document.createElement("script");
    tag_callback__script.className = "noted-temporary-function-tbr";
    tag_callback__script.setAttribute("type", "text/javascript");
    tag_callback__script.innerHTML = tag_callback__added;
    document.body.appendChild(tag_callback__script);
  });
};


/*


    3. Support functions


*/
addTag = function(params) {
  jsonpScript = document.createElement("script");
  jsonpScript.className = "noted-temporary-function-tbr";
  jsonpScript.src =  "//" +bookmarklet_server_host +"/add/tag_remotely/?" + jQuery.param(params);
  document.body.appendChild(jsonpScript);
}

getFaviconURL = function() {
  rel = "icon";
  if(document.querySelectorAll("link[rel~=" +rel +"]").length > 0)
    return encodeURIComponent(document.querySelectorAll("link[rel~=" +rel +"]")[0].href);
  else
    return encodeURIComponent("http://" +document.location.hostname +"/favicon.ico");
}

closeBookmarkletWindow = function() {
  $(".noted-bookmarklet").remove();
  $(".noted-temporary-function-tbr").remove();
}
