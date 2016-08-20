$(document).on('input', '.invite-list', function(){
  var emptyInviteFields = emptyFields($(".invite-list"))

  if(emptyInviteFields.length == 0) {
    addField();
  } 
  else if (emptyInviteFields.length > 1){
    $(this).remove();
    emptyInviteFields.last().focus()
  }
});

function emptyFields(invite_list){
  return invite_list.filter(function(){return this.value == ""});
}

function addField(){
  $(".invite-list").last().after('<input type="text" value name="emails[]" class="invite-list" placeholder="Enter another email">')
}
