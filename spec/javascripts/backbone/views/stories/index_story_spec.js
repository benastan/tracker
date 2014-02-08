describe('StoriesIndexStory', function() {
  var $el, elStubs, view;

  function makeStoriesIndexStory() {
    view = new StoriesIndexStory({
      el: $el
    });
  }

  beforeEach(function() {
    html = readFixtures('backbone/views/stories/index_story.html');

    $el = $(html);
  });

  afterEach(function() {
    view = undefined;
  });

  describe('#constructor', function() {
    beforeEach(function() {
      elStubs = {};
    });
    
    afterEach(function() {
      var key;

      for (key in elStubs) $el[key].restore();
    });

    it('makes $el droppable', function() {
      var droppableOptions;

      droppableOptions = { hoverClass: 'drop-hover' }
      
      elStubs.droppable = sinon.stub($el, 'droppable').returns(undefined);

      makeStoriesIndexStory();

      expect(elStubs.droppable.calledWith(droppableOptions)).toEqual(true); 
    });

    it('makes $el draggable', function() {
      var draggableOptions;

      draggableOptions = {
        revert: 'invalid',
        cursorAt: {
          left: 35,
          top: 35
        }
      }
      
      elStubs.draggable = sinon.stub($el, 'draggable').returns(undefined);

      makeStoriesIndexStory();

      expect(elStubs.draggable.calledWith(draggableOptions)).toEqual(true); 
    });
  });

  describe('getStoryStoryForm', function() {
    it('instantiates a StoryStoryForm', function() {
      var constructorStub;

      constructorStub = sinon.stub(window, 'StoryStoryForm');
      
      makeStoriesIndexStory();

      view.getStoryStoryForm();

      expect(constructorStub.called).toEqual(true);
    
      StoryStoryForm.restore();
    });
  });

  describe('#addChildStory', function() {
    var storyStoryForm, stub;
    
    beforeEach(function() {
      storyStoryForm = new StoryStoryForm({});
      
      sinon.stub(StoriesIndexStory.prototype, 'getStoryStoryForm').returns(storyStoryForm);

      makeStoriesIndexStory();
    });

    afterEach(function() {
      StoriesIndexStory.prototype.getStoryStoryForm.restore();
    })

    it('updates #story_story_child_story_id', function() {
      stub = sinon.stub(storyStoryForm, 'setChildStoryIdValue').returns(undefined);

      view.addChildStory('orangutan');

      expect(stub.calledWith('orangutan')).toEqual(true);
    });

    it('submits storyStoryForm', function() {
      stub = sinon.stub(storyStoryForm, 'submit').returns(undefined);

      view.addChildStory('orangutan');

      expect(stub.called).toEqual(true);
    });
  });
});