var _slice;

_slice = [].slice;

function IndexStory(options) {
  var view;

  view = this;

  Backbone.View.call(this, options);

  this.$el.on('ajax:success', '.new_story_story', function(e, storyStory) {
    view.renderChildStories(storyStory);
  });
}

IndexStory.prototype = new Backbone.View({});

IndexStory.prototype.renderChildStories = function(storyStory) {
  var $, $ul, subView;

  $ul = this.$('ul');

  subView = new IndexStoryChildStories({
    storyStory: storyStory
  });
  
  subView.render();

  $ul.replaceWith(subView.el);
};