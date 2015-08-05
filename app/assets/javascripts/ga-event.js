var GaEvents = function(selector) {
  this.elements = $(selector);
};

var fn = GaEvents.prototype;

fn.init = function() {
  this._bindEvents();
};

fn._bindEvents = function() {
  var self = this;

  this.elements.on('click', function(event){
    self._pushEvent($(this).data('ga-event'));
  });
};

fn._pushEvent = function(rawParams) {
  var params = rawParams.split(',');
  ga('send', 'event', params[0], params[1], params[2]);
};

$(document).ready(function() {
  new GaEvents('[data-ga-event]').init();
});
