describe('IndexStoryChildStories', function() {
  var view, stories, storyStory;

  beforeEach(function(done) {
    $.getJSON('spec/javascripts/fixtures/data/story_story.json').success(function(data) {
      storyStory = data;
      view = new IndexStoryChildStories({
        storyStory: storyStory
      });
      done();
    });
  });

  describe('#constructor', function() {
    it('sets #storyStory', function() {
      expect(view.storyStory).toEqual(storyStory);
      expect(view.storyStory.id).toEqual(1);
    });

    it('has a default template', function() {
      expect(view.template).toEqual(HoganTemplates['stories/_child_stories']);
    });
  });


  describe('#render', function() {
    it('renders a ul', function() {
      view.render();
      expect(view.el.tagName).toEqual('UL')
    });

    it('renders the template', function() {
      view.render();
      expect(view.el.innerHTML).toContainText('Child Story');
      expect(view.$el).toContainText('Child Story');
    });
  })
});