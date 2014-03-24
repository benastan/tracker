function StoriesIndex(options) {
  var view;

  Backbone.View.call(this, options);

  view = this;

  this.loadStoriesIndexStories();

  this.$el.on('drop', '.story', function(e, ui) {
    var $childStory, $parentStory, childStoryId, parentStoryView;

    $parentStory = $(this);

    $childStory = ui.draggable;

    childStoryId = $childStory.data('id');

    parentStoryView = view.findStoriesIndexStory($parentStory);

    parentStoryView.addChildStory(childStoryId);

    $childStory.remove();
  });
};

StoriesIndex.prototype = new Backbone.View({});

StoriesIndex.prototype.buildStoriesIndexStory = function(el) {
  var subview;

  subview = new StoriesIndexStory({
    el: el
  });

  return subview;
}

StoriesIndex.prototype.findStoriesIndexStory = function($story) {
  var id, stories, storyView;

  id = $story.attr('id');

  stories = this.stories;

  storyView = stories[id];

  return storyView;
};

StoriesIndex.prototype.loadStoriesIndexStories = function() {
  var $stories, stories, view;

  $stories = this.$el.find('> .story');

  stories = {};
  
  view = this;

  $stories.each(function() {
    var story;

    story = view.buildStoriesIndexStory(this);

    stories[this.id] = story;
  });

  this.stories = stories;
};