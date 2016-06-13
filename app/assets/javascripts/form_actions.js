$(document).on('input', '.mailing-list', function(){
  empty_fields = emptyFields($(".mailing-list"))

  if(empty_fields.length == 0) {
    addEmptyField();
  }else if (empty_fields.length > 1){
    $(this).remove();
    empty_fields.last().focus()
  }

});

function emptyFields(email_fields){
  return email_fields.filter(function(){return this.value == ""});
}

function addEmptyField(){
  $(".mailing-list").last().after('<input type="text" value name="emails[]" class="mailing-list">')
}
