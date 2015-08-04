// <div class='epic-votes' data-ev-id='2'></div>
// <script>
//   (function(d, s) {
//     var js, fjs = d.getElementsByTagName(s)[0];
//     js = d.createElement(s);
//     js.async = true;
//     js.src = '//localhost:8000/widget/epicvotes.js?version=1.0';
//     fjs.parentNode.insertBefore(js, fjs);
//   }(document, 'script'));
// </script>

try {
  window.EV || (function(window) {
    var httpRequest;

    var loadElection = function(electionId, callback) {
      if (window.XMLHttpRequest) { // Mozilla, Safari, IE7+ ...
        httpRequest = new XMLHttpRequest();
      } else if (window.ActiveXObject) { // IE 6 and older
        httpRequest = new ActiveXObject('Microsoft.XMLHTTP');
      }

      httpRequest.onreadystatechange = callback;
      httpRequest.open('GET', '/election/' + electionId, true);
      httpRequest.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      httpRequest.send();
    };

    var elections = document.getElementsByClassName('epic-votes');
    for (var i = 0; i < elections.length; i++) {
      var election = elections[i];

      if (!election.dataset.evId || election.dataset.evLoaded) {
        continue;
      }

      loadElection(election.dataset.evId, function() {
        if (httpRequest.readyState === 4) {
          election.innerHTML = httpRequest.responseText;
          election.dataset.evLoaded = true;
          // TODO
          // Fix the widget size and style classes
        }
      });
    }
  })(window);
} catch(e) {};