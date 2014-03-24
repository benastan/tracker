$('.story_menu_toggle').each(function() {
  var $story, $toggle;

  $toggle = $(this);

  $story = $toggle.parents('.story');

  $story.on('click', '.story_menu_toggle', function() {
    $story.toggleClass('focus_menu');

    return false;
  });

  $(document).on('click', function() {
    $story.toggleClass('focus_menu', false);
  });
});
