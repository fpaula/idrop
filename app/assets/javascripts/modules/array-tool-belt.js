var ArrayToolBelt ={
  combine: function(array) {
    var size = array.length;
    var result = [];
    for (i = 0; i < size; i++) {
      for (j = i + 1; j < size; j++) {
        result.push([array[i], array[j]]);
      }
    }

    return result;
  },

  shuffle: function(array) {
    var currentIndex = array.length, temporaryValue, randomIndex ;

    while (0 !== currentIndex) {
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;

      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }

    return array;
  },

  combineAndShuffle: function(array) {
    return this.shuffle(this.combine(array));
  }
}