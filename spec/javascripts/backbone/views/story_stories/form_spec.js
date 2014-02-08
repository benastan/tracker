describe('StoryStoryForm', function() {
  var view, $el;

  beforeEach(function() {
    var html;

    html = readFixtures('backbone/views/story_stories/form.html');

    $el = $(html);

    $childStoryId = $el.children(':first');

    view = new StoryStoryForm({
      el: $el
    });
  });

  describe('#getChildStoryId', function() {
    it('finds and returns #story_story_child_story_id', function() {
      expect(view.getChildStoryId()).toEqual($childStoryId);
    });
  });

  describe('#setChildStoryIdValue', function() {
    it('sets value of #story_story_child_story_id', function() {
      view.setChildStoryIdValue('popofvsky');

      expect($childStoryId).toHaveValue('popofvsky');
    });
  });

  describe('#submit', function() {
    it('triggers a submit event on the form element', function() {
      var eventSpy;

      eventSpy = spyOnEvent($el, 'submit');

      view.submit();

      expect(eventSpy).toHaveBeenTriggered()
    });
  });
});