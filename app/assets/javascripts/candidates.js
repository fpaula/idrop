var Candidates = function(candidates) {
  this.candidates = candidates;
};

var fn = Candidates.prototype;

fn.find = function(id) {
  return $.grep(this.candidates, function(entity) {
    return entity.id === id;
  })[0];
};

fn.ids = function() {
  return $.map(this.candidates, function(e) {
    return e.id;
  });
}