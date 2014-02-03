$('#stories_index').each(function() {
  var view;

  view = new IndexStory({
    el: this
  });

  view.$el.find('.new_story_story').on({
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