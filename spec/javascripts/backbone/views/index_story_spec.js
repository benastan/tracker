describe('IndexStory', function() {
  var html, view, $el, storyStory;

  beforeEach(function(done) {
    $.getJSON('spec/javascripts/fixtures/data/story_story.json').success(function(data) {
      storyStory = data;
      done();
    });

    html = readFixtures('backbone/views/index_story.html');

    $el = $(html);

    $form = $el.find('form');

    view = new IndexStory({
      el: $el.get(0)
    });
  });

  describe('event handling', function() {
    it('handles ajax:success', function() {
      spyOn(view, 'renderChildStories');
      
      $form.trigger('ajax:success', [ storyStory ]);

      expect(view.renderChildStories).toHaveBeenCalledWith(storyStory);
    });
  });

  describe('#renderChildStories', function() {
    it('renders child stories', function() {
      view.renderChildStories(storyStory);

      expect($el.find('ul')).toContainText('Child Story');
    });
  });
});