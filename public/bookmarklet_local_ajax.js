/*


      Bookmarklet Structure
      Updated 20150715


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
        3.4 Attaches event handlers to the interaction elements


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
      };
      // Use Script element injection to send the quote to the Ettúi server
      jsonpScript = document.createElement("script");
      jsonpScript.className = jsonpScript.className + "noted-temporary-function-tbr";
      jsonpScript.src =  "//" +bookmarklet_server_host +"/add/quote/?" + jQuery.param(params);
      document.body.appendChild(jsonpScript);

      /*

        Defines the look of the popup being created when you click the bookmarklet. 
        
        <div class="noted-bookmarklet">
          <div class="noted-spinner"></div>
        </div>

      */ 
      popup = document.createElement("div");
      popup.className = popup.className + "noted-bookmarklet";
      $(popup).html('<div class="noted-spinner"></div>');
      document.body.appendChild(popup);
      bookmarklet = $(".noted-bookmarklet");

        /*


        2.2.1 Define Quote success(...) callback


        */
        quote_callback__added = function success(data) {
          if(data) {
            session_data.quote_id = data.quote_id
            bookmarklet.append(data.html);

            // Remove spinner and since .noted-content-container is hidden per default -> Show it.
            bookmarklet.children(".noted-spinner").fadeOut('slow', function() {
              bookmarklet.children(".noted-content-container").fadeIn('slow');
            });

            // Makes buttons clickable (Event handlers reset due to re-render of items)
            attachEventHandlers();
          } 
        }


      /*


          2.2.2 Define Quote failed(...) callback


      */
      quote_callback__failed = function failed(data) {
        if(data) {
          bookmarklet.append(data.html);
          bookmarklet.children(".noted-spinner").fadeOut('slow', function() {
            bookmarklet.children(".noted-content-container").fadeIn('slow');
          });
        }
      }


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
        if(data) {
          bookmarklet.children('.noted-content-container').remove();
          bookmarklet.append(data.html);

          // .noted-content-container is hidden per default -> Show it.
          bookmarklet.children('.noted-content-container').show();

          // Makes buttons clickable (Event handlers reset due to re-render of items)
          attachEventHandlers();

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

    } // End of else {...} clause
  });
}


/*


    3. Support functions


*/
addTag = function(tag_name) {
  params = {
    user_token: current_user_token,
    quote_id: session_data.quote_id,
    callback: "added",
    tag: tag_name
  }
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

function attachEventHandlers() {
  $(".noted-tag").on('click', function() {
    tag_name = $(this).text();
    addTag(tag_name);
  });

  $("#noted-new-tag").on('keyup', function (e) {
    if (e.keyCode == 13) {
      tag_name = $(this).val();
      addTag(tag_name);
    }
  });

  $("#noted-new-tag-submit").on('click', function(e) {
    tag_name = $(this).siblings('#noted-new-tag').val();
    addTag(tag_name);
  });
}
