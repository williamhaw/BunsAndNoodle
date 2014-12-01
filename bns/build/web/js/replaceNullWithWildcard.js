function replaceNullWithWildcard(){
    var title = document.getElementById("title").value;
    var name = document.getElementById("name").value;
    var publisher = document.getElementById("publisher").value;
    var subject = document.getElementById("subject").value;

    if (title === "") { document.getElementById("title").value = ".*"; }
    if (name === "") { document.getElementById("name").value = ".*"; }
    if (publisher === "") { document.getElementById("publisher").value = ".*"; }
    if (subject === "") { document.getElementById("subject").value = ".*"; }
}

