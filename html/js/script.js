const container = document.getElementById("content")
const options = {
}
const editor = new JSONEditor(container, options);

let js = true; // Global displaying which info is presented
let tprint = null;
// set json
const initialJson = {
    "Array": [1, 2, 3],
    "Boolean": true,
    "Null": null,
    "Number": 123,
    "Object": {"a": "b", "c": "d"},
    "String": "Hello World"
}
editor.set(initialJson);

function show(element){
    element.style.display = "block";
}

function hide(element){
    element.style.display = "none";
}
function disableNUIfocus(boolean){
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "https://cd_devtools/close", true);                                                                                                                                                                                                                                                                                                                                      
    xhr.send(JSON.stringify({closed: boolean}));
}
function updatePlaintext(){
    document.getElementById("text-content").innerHTML = tprint;
}
window.addEventListener("message", (e) => {
    if(e.data.action == "show"){
        if(e.data.data){
            editor.set(e.data.data);
            show(document.getElementById("container"));
            tprint = e.data.tprint;
            updatePlaintext();
        } else console.error("You need to send a table in order to display it!")
    } else if(e.data.action == "hide"){
        hide(document.getElementById("container"));
    } else if(e.data.action == "update"){
        if(e.data.data){
            editor.set(e.data.data);
            tprint = e.data.tprint;
            updatePlaintext();
        } else console.error("You need to send a table in order to display it!")
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key == "Escape") {
        hide(document.getElementById("container"));
        disableNUIfocus(true);
    }
});

document.addEventListener('mousedown', function(e) {
    if(e.which == 2){
      disableNUIfocus(false);
    }
  });

document.getElementById("menu-close").addEventListener("mousedown", (e) => {
    hide(document.getElementById("container"));
    disableNUIfocus(true);
});

// Notifications
document.getElementById("menu-copy").addEventListener("click", () => {
    if(js)
    document.getElementById("clipboard-input").value = JSON.stringify(editor.get());
    else document.getElementById("clipboard-input").value = tprint;
    //                             if js copy json else copy lua table
    document.getElementById("clipboard-input").select();
    let check = document.execCommand("copy");

    if(check) {
        document.getElementById("footer").classList.add("success");
        document.getElementById("footer-info").innerHTML = "Copied!";
        setTimeout(() => {
            document.getElementById("footer").classList.remove("success");
            document.getElementById("footer-info").innerHTML = " ";
        }, 2000);
    } else {
        document.getElementById("footer").classList.add("failed");
        document.getElementById("footer-info").innerHTML = "Failed to copy!";

        setTimeout(() => {
            document.getElementById("footer").classList.remove("failed");
            document.getElementById("footer-info").innerHTML = " ";
        }, 2000);
    }
});

// Lua text
document.getElementById("menu-view").addEventListener("click", () => {
    if(js){
        document.getElementById("content").style.display = "none";
        document.getElementById("text-content").style.display = "block";
        js = false;

        document.getElementById("menu-view").innerHTML = "JSON View";
    } else {
        document.getElementById("content").style.display = "block";
        document.getElementById("text-content").style.display = "none";

        document.getElementById("menu-view").innerHTML = "LUA View";

        js = true
    }
})