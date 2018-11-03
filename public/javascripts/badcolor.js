window.onload = function() {
    var colorpicker = document.getElementById('colorpicker');
    var label = document.getElementById('colorpicker-label');
    var button = document.getElementById('registerbutton');
    colorpicker.onchange = function() {
        var newValue = this.value;
        var red = parseInt(newValue.slice(1, 3), 16);
        var green = parseInt(newValue.slice(3, 5), 16);
        var blue = parseInt(newValue.slice(5, 7), 16);
        if (red + green + blue < 120) {
            label.innerHTML = 'pick <strong>lighter</strong> color:';
            button.disabled = true;
        } else if (red + green + blue > 666) {
            label.innerHTML = 'pick <strong>darker</strong> color:';
            button.disabled = true;
        } else {
            label.innerHTML = 'pick your color:';
            button.disabled = false;
        }
    }
}
