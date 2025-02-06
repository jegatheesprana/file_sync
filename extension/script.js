let content = "";
async function getFileName() {
    content = await fetch("http://localhost:8000").then(res => res.text())
    document.title = content
}

document.addEventListener("keydown", function (event) {
    if (event.ctrlKey && event.shiftKey && event.code === "KeyC") {
        navigator.clipboard.writeText(content);
        event.preventDefault();
    }
});

setInterval(getFileName, 100)
