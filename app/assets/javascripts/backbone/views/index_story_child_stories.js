function IndexStoryChildStories(options) {
  Backbone.View.call(this, options);

  this.storyStory = options.storyStory;

  this.setElement(document.createElement('ul'));
}

IndexStoryChildStories.prototype = new Backbone.View();

IndexStoryChildStories.prototype.template = HoganTemplates['stories/_child_stories']

IndexStoryChildStories.prototype.render = function() {
  var $el, html, template, storyStory;

  $el = this.$el;

  template = this.template;

  storyStory = this.storyStory;

  html = template.render(storyStory);

  $el.html(html);
};