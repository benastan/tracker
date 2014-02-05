var _slice;

_slice = [].slice;

function IndexStory(options) {
  var view;

  view = this;

  Backbone.View.call(this, options);

  this.$el.on('ajax:success', '.new_story_story', function(e, storyStory) {
    view.renderChildStories(storyStory);
  });

  this.$el.on('sortupdate', function(e, ui) {
    view.updateStoryOrderPosition();
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

IndexStory.prototype.updateStoryOrderPosition = function() {
  var $form, $stories, $storyOrderPositionPosition, newPosition;

  $form = this.$('.edit_story_order_position');

  $stories = this.$el.siblings().andSelf();

  $storyOrderPositionPosition = $form.find('#story_order_position_position');

  newPosition = $stories.index(this.el);

  $storyOrderPositionPosition.val(newPosition);

  $form.trigger('submit');
};
