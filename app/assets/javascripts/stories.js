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


$(document).on('click', '.submitForm', function() {
  var $link, $form;
  $link = $(this);
  $form = $link.parents('form');
  $form.submit();
});

$(document).on('change', '#stories_sidebar h2 input[type="checkbox"]', function(e) {
  $(this).parents('form').submit();
});

$(document).on('ajax:before', '#stories_sidebar h2 form', function(e) {
  var $form, $list;
  $form = $(this);
  $list = $form.parent().siblings();
  $list.toggleClass('hide');
  e.preventDefault();
  e.stopPropagation();
});
