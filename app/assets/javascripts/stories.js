$('#stories_index').each(function() {
  $storiesIndexRoot = $(this)

  $stories = $storiesIndexRoot.children('.story')

  $stories.each(function() {
    var view;

    view = new IndexStory({
      el: this
    });

    view.$el.find('form').on({
      'ajax:success': function(storyStory) {
        var $form, $check, html;
        
        $form = $(this);
        $check = $form.find('.showOnSuccess');

        $check.show();

        function hideCheck() {
          $check.fadeOut()
        }

        setTimeout(hideCheck, 1000);
      }
    });
  });
  
  $storiesIndexRoot.sortable({
    forceHelperSize: false,
    cursorAt: {
      left: 50,
      top: 50
    }
  });

  $storiesIndexRoot.disableSelection();

  $storiesIndexRoot.on('sortupdate', function(e, ui) {
    $(ui.item).triggerHandler('sortupdate', arguments);
  });
});