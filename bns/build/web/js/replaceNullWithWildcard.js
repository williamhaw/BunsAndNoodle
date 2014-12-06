function replaceNullWithWildcard(){
    var title = document.getElementById("title").value;
    var authors = document.getElementById("authors").value;
    var publisher = document.getElementById("publisher").value;
    var subject = document.getElementById("subject").value;

    if (title === "") { document.getElementById("title").value = ".*"; }
    if (authors === "") { document.getElementById("authors").value = ".*"; }
    if (publisher === "") { document.getElementById("publisher").value = ".*"; }
    if (subject === "") { document.getElementById("subject").value = ".*"; }
}

