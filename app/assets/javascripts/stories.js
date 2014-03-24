$('.story_menu').each(function() {
  var $menu, $story, $toggle;

  $menu = $(this);

  $story = $menu.parents('.story');

  $story.on('click', '.story_menu_toggle', function() {
    $story.toggleClass('focus_menu');

    return false;
  });

  $(document).on('click', function() {
    $story.toggleClass('focus_menu', false);
  });
});