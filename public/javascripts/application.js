// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function scroll(dom_object, target, i) {
    var i = i;
    var height = $(document).height();
    if (i < 5) {
        dom_object = dom_object.next();
        var complete_target = target + i + "')"
        $.scrollTo(eval(complete_target), height *  14, {
            onAfter: function() {
                $.scrollTo(0, height * 1);
                dom_object.children().click();
                scroll(dom_object, target, i + 1 );
            }});
    } else {
        window.location.reload();
    }
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}
function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function start_beamer_modus() {
    var first_li = $('div#tabs ul li').first();
    scroll(first_li, "$('span#tab", 1);
};

$(function() {
var toggleLoading = function() { $("#loading").toggle() };
  $("#tool-form")
    .bind("ajax:loading",  toggleLoading)
    .bind("ajax:complete", toggleLoading);
});


var chart1; // globally available

$(document).ready(function() {


$("#table-relax").tablesorter( {sortList: [[4,1]]} );
$("#table-power").tablesorter( {sortList: [[4,1]]} );
$("#table-leipzig").tablesorter( {sortList: [[4,1]]} );
$("#table-all").tablesorter( {sortList: [[4,1]]} );
$("#table-achtzehn").tablesorter( {sortList: [[4,1]]} );
$("#table-seniors").tablesorter( {sortList: [[4,1]]} );
$("#table-relax-boulder").tablesorter();
$("#table-power-boulder").tablesorter();

var $tabs = $('#tabs').tabs().scrollabletab();

$("#hall_hall_id").change(function(){
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');
    $.ajax({
         type: 'POST',
         url: 'change_hall',
         data: {
           hall_id: $('#hall_hall_id option:selected').val(),
           authenticity_token: csrf_token,
         success: function(){}
        }});
    return false;
})

})