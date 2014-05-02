$(document).ready(function () {

  console.log($('.posts').text());

  $(".click").click(function(e) {
    e.preventDefault();
    // $("#resultBlock").html("Getting the funk - stand by...");
    $.get("http://10.0.1.4:3000", function(data) {
      // $("#resultBlock").html(data);
      // console.log(data)
      $('.title').append('Ron');

    })
  });

  // $('#result-table').hide();
  // $('#submit-deck-button').show();

  // $("#target").submit(function(event){
  //   event.preventDefault();
  //   var str = $( '#target' ).serialize();
  //   var input = $("input:radio[name=option]:checked").val();
  //   var realAnswer = $( '#real-answer').val();
  //   var data = {"option": input, "real_answer": realAnswer};

  //   $.post('/deck/result', data, function(response) {
  //     $('#submit-deck-button').hide();

  //     if (response["result"] === "CORRECT") {
  //       var styledresult = "<p class='correct'>" + response["result"] + "</p>"
  //     }
  //     else {
  //       var styledresult = "<p class='incorrect'>" + response["result"] + "</p>"
  //     };

  //     $('#result').append(styledresult);
  //     $('#real_answer').append(response["real_answer"]);
  //     $('#user_guess').append(response["user_guess"]);
  //     $("input[type=radio]").attr("disabled", true);
  //     $('#result-table').show();
  //   });
  // });

  // $('#new_card').submit(function(event){
  //   event.preventDefault();
  //   var term = $('#term').val();
  //   var definition = $('#definition').val();
  //   var data = {term: term, definition: definition}

  //   $.post("/cards/new", data, function(response){
  //     $('#term').val('').focus();
  //     $('#definition').val('');
  //   });
  // });
});
