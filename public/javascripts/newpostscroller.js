window.onload = function() {
    var textarea = document.getElementById("new-post-text");
	var newPostSection = document.getElementById('new-post');
	textarea.addEventListener('input', function() {
		this.style.height = 'auto';
		this.style.height = (this.scrollHeight) + 'px';
		newPostSection.style.height = 'auto';
	}, false);
	textarea.dispatchEvent(new Event('input'));
}
