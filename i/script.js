const refs = document.getElementById('footer-links').querySelectorAll("a");
document.onkeyup = function(e) {
    refs.forEach(
        function(elem, idx, lst) {
            if (elem.getAttribute('data-shortcut') == this) {
                elem.click();
            }
        },
        e.key.toLowerCase()
    );
};
