function StoriesIndexStory(options) {
  Backbone.View.call(this, options);

  this.$el.droppable({
    hoverClass: 'drop-hover'
  });

  this.$el.draggable({
    revert: 'invalid',
    cursorAt: {
      left: 35,
      top: 35
    }
  });
};

StoriesIndexStory.prototype = new Backbone.View({});

StoriesIndexStory.prototype.getStoryStoryForm = function() {
  var storyStoryForm;

  storyStoryForm = new StoryStoryForm({
    el: this.$('.new_story_story')
  });

  return storyStoryForm;
};

StoriesIndexStory.prototype.addChildStory = function(value) {
  var storyStoryForm;

  storyStoryForm = this.getStoryStoryForm();

  storyStoryForm.setChildStoryIdValue(value);

  storyStoryForm.submit();
};
