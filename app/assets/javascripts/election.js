var Election = function(electionId, candidates) {
  this.candidates = new Candidates(candidates);
  this.combineCandidates();
  this.electionId = electionId;

  this.round = 0;
  this.votesCount = 0;
  this.currentInLeft = 0;
  this.currentInRight = 0;

  this.root = $('#election');
  this.leftPanel = this.root.find('#left');
  this.rightPanel = this.root.find('#right');
  this.nextButton = this.root.find('[data-next-candidates]');
  this.votesCounter = this.root.find('[data-votes-counter]');

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
    var candidateId = $(this).data('id'),
        userId = 1;

    self._vote(self.electionId, candidateId, userId);
  });
}

fn.combineCandidates = function() {
  var ids = this.candidates.ids();
  this.combinations = ArrayToolBelt.combineAndShuffle(ids);
};

fn.nextCandidates = function() {
  var id1 = this.combinations[this.round][0],
      id2 = this.combinations[this.round][1];

  // The fade effect must be applied only if the image changes
  // between rounds
  if (this.currentInLeft != id1) {
    this._prepareCandidate(this.leftPanel, id1);
  }

  if (this.currentInRight != id2) {
    this._prepareCandidate(this.rightPanel, id2);
  }

  this.currentInLeft = id1;
  this.currentInRight = id2;

  this.round += 1;

  if (this.round == this.combinations.length) {
    this.finish();
  }
};

fn._prepareCandidate = function(panel, id) {
  var self = this,
      candidate = this.candidates.find(id),
      image = panel.find('[data-candidate]'),
      subtitle = panel.find('[data-subtitle]');

  image.fadeOut(function() {
    image.attr('src', candidate.image_url);
    subtitle.text(candidate.name);
    image.data('id', id);
    image.fadeIn(function(){
      self._adjustSubtitleToImage(image, subtitle);
    });
  });
};

fn._adjustSubtitleToImage = function(image, subtitle) {
  var imageWidth = image.width();

  if (imageWidth > 0) {
    subtitle.css('margin-left', (300 - imageWidth) / 2);
    subtitle.width(imageWidth);
  } else {
    subtitle.width(300).css('margin-left', 0);
  }
}

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
    self._updateVotesCounter();
    self.nextCandidates();
  })
  .fail(function(data) {
    alert('Não foi possível incluir seu voto, tente novamente');
    console.log(data);
  })
};

fn._updateVotesCounter = function() {
  this.votesCount += 1;
  if (this.votesCount == 1) {
    this.votesCounter.text('Você votou em 1 duelo');
  } else {
    this.votesCounter.text('Você votou em '+ this.votesCount + ' duelos');
  }
}