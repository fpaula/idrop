var Election = function(electionId) {
  this.electionId = electionId;

  this.votesCount = 0;

  this.root = $('#election');
  this.finishedElection = $('[data-finished-election]');
  this.leftPanel = this.root.find('#left');
  this.rightPanel = this.root.find('#right');
  this.nextButton = $('[data-next-candidates]');
  this.votesCounter = $('[data-votes-counter]');
  this.combinationId = this.root.find('[data-combination]').data('combination');

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

  // Avoid freak clicks
  this.root.data('click-enabled', true);

  this.nextButton.on('click', self._skip.bind(self));

  this.root.find('[data-candidate-picture]').on('click', function() {
    if (self.root.data('click-enabled')) {
      self.root.data('click-enabled', false);

      self._vote($(this).attr('data-id'), function() {
        self.root.data('click-enabled', true);
      });
    }
  });
}

fn.nextCandidates = function(combination, callback) {
  if (combination) {
    var candidateLeft = combination.candidate_1;
    var candidateRight = combination.candidate_2;

    this.combinationId = combination.id;

    // The fade effect must be applied only if the image changes
    // between rounds
    if (this.currentInLeft != candidateLeft.id) {
      this._prepareCandidate(this.leftPanel, candidateLeft, callback);
    }

    if (this.currentInRight != candidateRight.id) {
      this._prepareCandidate(this.rightPanel, candidateRight, callback);
    }

    this.currentInLeft = candidateLeft.id;
    this.currentInRight = candidateRight.id;
  } else {
    this.finish();
  }
};

fn._prepareCandidate = function(panel, candidate, callback) {
  var self = this,
      image = panel.find('[data-candidate-picture]'),
      subtitle = panel.find('[data-subtitle]'),
      mask = panel.find('[data-mask]');

  image.fadeOut(function() {
    image.css('background-image', 'url(' + candidate.image_url + ')');
    subtitle.text(candidate.name);
    image.attr('data-id', candidate.id);
    self._updateCredits(panel, candidate);
    image.fadeIn(function() {
      try { callback() } catch(e) {};
    });
  });
};

fn._skip = function() {
  this._vote();
};

fn._vote = function(candidateId, callback) {
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

    self.nextCandidates(combination, callback);
  })
  .fail(function(data) {
    alert('Ocorreu um erro inesperado, tente novamente mais tarde.');
  })
};

fn._updateVotesCounter = function() {
  this.votesCount += 1;
  var duelWord = this.votesCount === 1 ? 'duelo' : 'duelos';
  this.votesCounter.text('Você votou em ' + this.votesCount + ' ' + duelWord);
};

fn._updateCredits = function(panel, candidate) {
  if(candidate.image_license == null) {
    panel.find('.attribution').html('');
  } else {
    var attribution = panel.find('.attribution').html(''),
        origin = '',
        author = '',
        image_license = '',
        modified_image = '',
        cc = candidate.image_license.split(' ');

    if(candidate.image_original_title != null) {
      origin = $('<a>').attr('href', candidate.image_original_url).text(candidate.image_original_title).prop('outerHTML');
    }

    if(candidate.image_author_name != null) {
      author = ' by ' + $('<a>').attr('href', candidate.image_author_url).text(candidate.image_author_name).prop('outerHTML');
    }

    if(candidate.image_license != null) {
      image_license = ' is licensed under ' + $('<a>').attr('href', "http://creativecommons.org/licenses/" + cc[1].toLowerCase() + "/" + cc[2] + "/").text(candidate.image_license).prop('outerHTML');
    }

    if(candidate.modified_image_id != null) {
      modified_image = ' Croped from original';
    }

    attribution.append(origin).append(author).append(image_license).append(modified_image);
  }
};