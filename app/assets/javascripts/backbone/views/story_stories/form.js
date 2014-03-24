function StoryStoryForm(options) {
  Backbone.View.call(this, options);
}

StoryStoryForm.prototype = new Backbone.View({});

StoryStoryForm.prototype.getChildStoryId = function() {
  return this.$('#story_story_child_story_id');
};

StoryStoryForm.prototype.setChildStoryIdValue = function(value) {
  var $childStoryId;

  $childStoryId = this.getChildStoryId();

  $childStoryId.val(value);
};

StoryStoryForm.prototype.submit = function() {
  var $el;

  $el = this.$el;

  $el.trigger('submit');
}
