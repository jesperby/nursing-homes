jQuery(document).ready(function($) {

  // Create slideshow if there's more than one images for a nursing home
  var $slideshow = $('#slideshow');
  if ($slideshow.length && $slideshow.find('.images > img').length > 1) {

    var $count = $slideshow.find('.controls .count');
    var total = $slideshow.find('.images > img').length;
    $slideshow.find('.controls').show();
    $count.text('Bild 1 av ' + total);

    $slideshow.find('.images').cycle({
      fx: 'fade',
      timeout: 0,
      speed: 400,
      next: '#slideshow .controls .next, #slideshow img',
      prev: '#slideshow .controls .prev',
      onPrevNextEvent: function(isNext, index, slideElement) {
        $count.text('Bild ' + (index + 1) + ' av ' + total);
        $slideshow.css('z-index', '0');
      }
    });
  }
});
