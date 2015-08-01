var Election = function(electionId, candidates) {
  this.candidates = new Candidates(candidates);
  this.electionId = electionId;

  this.round = 0;
  this.combineCandidates();

  this.currentInLeft = 0;
  this.currentInRight = 0;

  this.root = $('#election');
  this.leftImage = this.root.find('[data-left-candidate]');
  this.rightImage = this.root.find('[data-right-candidate]');
  this.nextButton = this.root.find('[data-next-candidates]');
  this._bindEvents();
};

var fn = Election.prototype;

fn.start = function() {
  this.nextCandidates();
};

fn.finish = function() {
  this.root.html('END OF GAME');
};

fn._bindEvents = function() {
  var self = this;
  this.nextButton.on('click', function() {
    self.nextCandidates();
  });

  this.root.find('[data-candidate]').on('click', function() {
    var candidateId = $(this).data('id');
    var userId = 1;
    self._vote(self.electionId, candidateId, userId);
  });
}

fn.combineCandidates = function() {
  var ids = this.candidates.ids();
  this.combinations = ArrayToolBelt.combineAndShuffle(ids);
};

fn.nextCandidates = function() {
  var id1 = this.combinations[this.round][0];
  var id2 = this.combinations[this.round][1];

  // The fade effect must be applied only if the image changes
  // between rounds
  if (this.currentInLeft != id1) {
    this._prepareImage(this.leftImage, id1);
  }

  if (this.currentInRight != id2) {
    this._prepareImage(this.rightImage, id2);
  }

  this.currentInLeft = id1;
  this.currentInRight = id2;

  this.round += 1;

  if (this.round == this.combinations.length) {
    this.finish();
  }
};

fn._prepareImage = function(image, id) {
  var candidate = this.candidates.find(id);

  image.fadeOut(function() {
    image.attr('src', candidate.image);
    image.fadeIn();
  });
};

fn._vote = function(election_id, candidate_id, user_id) {
 var self = this;

 $.post('/votes', {
    'vote': {
      'election_id': election_id,
      'candidate_id': candidate_id,
      'user_id': user_id
    }
  })
  .done(function(data) {
    self.nextCandidates();
  })
  .fail(function(data) {
    alert('Não foi possível incluir seu voto, tente novamente');
    console.log(data);
  })
};