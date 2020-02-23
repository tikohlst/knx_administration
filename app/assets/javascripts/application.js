// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require bootstrap-toggle
//= require rails-ujs
//= require activestorage
//= require gauge.min.js
//= require jquery.keyboard.js
//= require jquery.keyboard.extension-typing.js
//= require_tree .

$(document).ready(function() {
    // Set the actual sorting in the search form, so the sorting can stay the same
    $(document).on('click', '.justify-content-between > div > .navbar-brand > .btn-group > a', function() {
        $(this).attr('href').match(/sort_by=(.*)$/g);
        var sort_by = RegExp.$1;
        $('#actual_sort_by').val(sort_by.toString());
    });

    $('#user_username')
        .keyboard({
            openOn : null,
            stayOpen : true,
            layout : 'qwerty'
        })
        .addTyping();

    $('#user_password')
        .keyboard({
            openOn : null,
            stayOpen : true,
            layout : 'qwerty'
        })
        .addTyping();

    $('#keyboard_username').click(function(){
        var kb = $('#user_username').getkeyboard();
        // close the keyboard if the keyboard is visible and the button is clicked a second time
        if ( kb.isOpen ) {
            kb.close();
        } else {
            kb.reveal();
        }
    });

    $('#keyboard_password').click(function(){
        var kb = $('#user_password').getkeyboard();
        // close the keyboard if the keyboard is visible and the button is clicked a second time
        if ( kb.isOpen ) {
            kb.close();
        } else {
            kb.reveal();
        }
    });
});
