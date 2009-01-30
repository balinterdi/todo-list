function delete_todo(id) {
    return function() {
        $.post("/" + id, function() { alert('todo deleted.') });
    }
}