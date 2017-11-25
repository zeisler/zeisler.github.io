$(function() {
	var now = new Date();
	$('[data-posttime]').each(function() {
		var post_time = new Date($(this).data('posttime'));
		
		if(post_time > now) {
			if($(this).is('article')) {
				window.location.href = '/404.html';
			} else {
				$(this).hide();
			}
		}
	});
});