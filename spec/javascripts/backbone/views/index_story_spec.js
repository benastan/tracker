describe('IndexStory', function() {
  var html, view, $el, storyStory;

  beforeEach(function(done) {
    $.getJSON('spec/javascripts/fixtures/data/story_story.json').success(function(data) {
      storyStory = data;
      done();
    });

    html = readFixtures('backbone/views/index_story.html');

    $el = $(html);

    $newStoryStoryForm = $el.find('.new_story_story');

    $editStoryOrderPosition = $el.find('.edit_story_order_position');

    $storyOrderPositionPosition = $el.find('#story_order_position_position');

    view = new window.IndexStory({
      el: $el.get(0)
    });
  });

  describe('event handling', function() {
    it('handles ajax:success', function() {
      spyOn(view, 'renderChildStories');
      
      $newStoryStoryForm.trigger('ajax:success', [ storyStory ]);

      expect(view.renderChildStories).toHaveBeenCalledWith(storyStory);
    });

    it('submits .edit_story_order_position on sortupdate', function() {
      spyOn(view, 'updateStoryOrderPosition');

      $el.trigger('sortupdate');

      expect(view.updateStoryOrderPosition).toHaveBeenCalled();
    });
  });

  describe('#renderChildStories', function() {
    it('renders child stories', function() {
      view.renderChildStories(storyStory);

      expect($el.find('ul')).toContainText('Child Story');
    });
  });

  describe('#updateStoryOrderPosition', function() {
    var eventSpy, $indexStub, $fakeStory;

    beforeEach(function() {
      $indexStub = sinon.stub($.fn, 'index');

      $indexStub.withArgs($el.get(0)).returns('99');
    });

    it('submits the StoryOrderPosition form', function() {
      eventSpy = spyOnEvent($editStoryOrderPosition, 'submit');

      view.updateStoryOrderPosition();

      expect($storyOrderPositionPosition).toHaveValue('99');

      expect(eventSpy).toHaveBeenTriggered();
    })
  });
});