function randomColor() {
    var range = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c'];
    result = '#';
    for (var i = 0; i < 6; i++) {
        result += range[Math.floor(Math.random() * range.length)];
    }
    return result;
}

window.onload = function() {
    var colorboard = document.getElementById('colorboardword');
    var oldText = colorboard.textContent;
    var result = '';
    for (var i = 0; i < oldText.length; i++) {
        result += '<span style="color: ' + randomColor() + '">' + oldText[i] + '</span>';
    }
    colorboard.innerHTML = result;
}
