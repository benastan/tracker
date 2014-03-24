describe('StoriesIndex', function() {
  var $el, view;

  function newStoriesIndex() {
    view = new StoriesIndex({
      el: $el.get(0)
    });
  }

  beforeEach(function() {
    var html

    html = readFixtures('backbone/views/stories/index.html');
    
    $el = $(html);
  });

  describe('#constructor', function() {
    var stub;
    
    beforeEach(function() {
      stub = sinon.stub(StoriesIndex.prototype, 'loadStoriesIndexStories');

      stub.returns(null);

      newStoriesIndex();
    });

    afterEach(function() {
      StoriesIndex.prototype.loadStoriesIndexStories.restore();
    });

    it('instantiates story subviews', function() {
      expect(stub.called).toEqual(true);
    });
  });

  describe('drop event listener', function() {
    var $childStory, $parentStory, childStoryView, parentStoryView;

    beforeEach(function() {
      newStoriesIndex();

      parentStoryView = view.stories.story_2;

      $childStory = $el.children().eq(0);
      
      $parentStory = $el.children().eq(1);

      ui = { draggable: $childStory };

      sinon.stub($childStory, 'data').withArgs('id').returns('jungle man');
    });

    function triggerDropEvent() {
      $parentStory.trigger('drop', ui);
    }

    it('calls addChildStory on the parent story view', function() {
      var addChildStoryToParent;

      addChildStoryToParent = sinon.stub(parentStoryView, 'addChildStory').returns(undefined);
      
      triggerDropEvent();
      
      expect(addChildStoryToParent.calledWith('jungle man')).toEqual(true);
    });

    it('removes the child story', function() {
      var removeChildStory;

      removeChildStory = sinon.stub($childStory, 'remove');
      
      triggerDropEvent();

      expect(removeChildStory.called).toEqual(true);
    });
  });

  describe('#buildStoriesIndexStory', function() {
    var el, subview;
    
    beforeEach(function() {
      el = document.createElement('ul');

      newStoriesIndex();

      subview = view.buildStoriesIndexStory(el);
    });
    
    it('instantiates a StoriesIndexStory', function() {
      expect(subview instanceof StoriesIndexStory).toEqual(true);
    });

    it('passes the correct object', function() {
      expect(subview.el).toEqual(el);
    });
  });

  describe('#findStoriesIndexStory', function() {
    it('finds a StoriesIndexStory', function() {
      var $story, storyView;

      $story = $('<div id="story_1">');

      newStoriesIndex();

      storyView = view.findStoriesIndexStory($story);

      expect(storyView).toEqual(view.stories.story_1);
    });
  });

  describe('#loadStoriesIndexStories', function() {
    beforeEach(function() {
      newStoriesIndex();

      sinon.stub(view, 'buildStoriesIndexStory')
        .onFirstCall().returns('java')
        .onSecondCall().returns('script');

      view.loadStoriesIndexStories();
    });

    it('loads stories from the DOM', function() {
      expect(_.keys(view.stories).length).toEqual(2);
    });

    it('keys #stories hash by id attribute', function() {
      expect(_.keys(view.stories)).toEqual([ 'story_1', 'story_2' ]);
    });

    it('stores IndexStory instances in values of #stories hash', function() {
      expect(_.values(view.stories)).toEqual([ 'java', 'script' ]);
    });
  });
});