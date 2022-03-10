var selectedItem = sessionStorage.getItem("SelectedItem");  
$('#programminglanguage').val(selectedItem);

$('#programminglanguage').change(function() { 
    var dropVal = $(this).val();
    sessionStorage.setItem("SelectedItem", dropVal);
});