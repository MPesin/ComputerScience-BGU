function check() {
    
    var name = document.forms["frm"]["name"].value; 
    var email = document.forms["frm"]["email"].value;
    var message = document.forms["frm"]["msg"].value;
    if(name == ""){
        window.alert("please fill your name");
        return false;
    } else if(email == ""){
        window.alert("please fill your email");
        return false;
    } else {
        var strd = email.indexOf("@");
        var dot = email.lastIndexOf(".");
        if (strd == -1 || dot<strd) {
            alert("Not a valid e-mail address");
            return false;
        } else if(message == ""){
            window.alert("please write a message");
            return false;
       }
    }
    return true;   
}