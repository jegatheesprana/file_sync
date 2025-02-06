async function getFileName() {
    const content = await fetch("http://localhost:8000").then(res => res.text())
    document.title = content
}

setInterval(getFileName, 100)
