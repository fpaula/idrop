var app = angular.module('epicvotes', []);

app.controller('ElectionController', function($scope, $http) {
  this.combination = null;
  this.has_combination = false;

  this.retrieveCombination = function() {
    var response = $http.get('/election/7/combination');
    var self = this;

    response.success(function(data, status, headers, config){
      console.log(data);
      self.combination = data;
      self.has_combination = true;
    });

    response.error(function(data, status, headers, config){
      console.log('fronhou');
    });
  };

  this.retrieveCombination();
});

/*var Election = function(electionId) {
  this.electionId = electionId;

  this.votesCount = 0;

  this.root = $('#election');
  this.finishedElection = $('[data-finished-election]');
  this.leftPanel = this.root.find('#left');
  this.rightPanel = this.root.find('#right');
  this.nextButton = this.root.find('[data-next-candidates]');
  this.votesCounter = this.root.find('[data-votes-counter]');
  this.combinationId = this.root.find('[data-combination]').attr('data-combination');

  this.currentInLeft = this.leftPanel.find('[data-id]').attr('data-id');
  this.currentInRight = this.rightPanel.find('[data-id]').attr('data-id');

  this._bindEvents();
};

var fn = Election.prototype;

fn.finish = function() {
  var self = this;
  this.root.fadeOut(function() {
    self.finishedElection.fadeIn('slow');
  });
};

fn._bindEvents = function() {
  var self = this;
  this.nextButton.on('click', self._skip.bind(self));

  this.root.find('[data-candidate-picture]').on('click', function() {
    var candidateId = $(this).attr('data-id');
    self._vote(candidateId);
  });
}

fn.nextCandidates = function(combination) {
  if (combination) {
    var candidateLeft = combination.candidate_1;
    var candidateRight = combination.candidate_2;

    this.combinationId = combination.id;

    // The fade effect must be applied only if the image changes
    // between rounds
    if (this.currentInLeft != candidateLeft.id) {
      this._prepareCandidate(this.leftPanel, candidateLeft);
    }

    if (this.currentInRight != candidateRight.id) {
      this._prepareCandidate(this.rightPanel, candidateRight);
    }

    this.currentInLeft = candidateLeft.id;
    this.currentInRight = candidateRight.id;
  } else {
    this.finish();
  }
};

fn._prepareCandidate = function(panel, candidate) {
  var self = this,
      image = panel.find('[data-candidate-picture]'),
      subtitle = panel.find('[data-subtitle]'),
      mask = panel.find('[data-mask]');

  image.fadeOut(function() {
    image.css('background-image', 'url(' + candidate.image_url + ')');
    subtitle.text(candidate.name);
    image.attr('data-id', candidate.id);
    image.fadeIn();
  });
};

fn._skip = function() {
  this._vote();
};

fn._vote = function(candidateId) {
  var self = this,
     userId = 1;

  $.post('/votes', {
    'vote': {
      'election_id': self.electionId,
      'candidate_id': candidateId,
      'user_id': userId,
      'candidate_combination_id': self.combinationId
    }
  })
  .done(function(combination) {
    if (candidateId) {
      self._updateVotesCounter();
    }

    self.nextCandidates(combination);
  })
  .fail(function(data) {
    alert('Ocorreu um erro inesperado, tente novamente mais tarde.');
  })
};

fn._updateVotesCounter = function() {
  this.votesCount += 1;
  var duelWord = this.votesCount === 1 ? 'duelo' : 'duelos';
  this.votesCounter.text('Você votou em ' + this.votesCount + ' ' + duelWord);
}
*/