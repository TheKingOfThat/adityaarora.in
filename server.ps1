$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:7621/')
$listener.Start()
Write-Host 'Server started on http://localhost:7621'
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $urlPath = $req.Url.LocalPath
    if ($urlPath -eq '/') { $urlPath = '/index.html' }
    $file = 'C:\Users\adity\.gemini\antigravity\scratch' + $urlPath
    if (Test-Path $file -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ext = [System.IO.Path]::GetExtension($file)
        if ($ext -eq '.html') { $res.ContentType = 'text/html; charset=utf-8' }
        elseif ($ext -eq '.png') { $res.ContentType = 'image/png' }
        elseif ($ext -eq '.jpg' -or $ext -eq '.jpeg') { $res.ContentType = 'image/jpeg' }
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $res.StatusCode = 404
    }
    $res.OutputStream.Close()
}
