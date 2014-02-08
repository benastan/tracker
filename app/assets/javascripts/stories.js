$('#unblocked_stories, #epic_stories').each(function() {
  new StoriesIndex({
    el: this
  });
});