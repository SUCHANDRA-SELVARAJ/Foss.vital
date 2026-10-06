$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "HTTP server running on http://localhost:8080/ (No-Cache Mode)"
while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $filePath = "c:\Users\sucha\Desktop\foss\index.html"
        if (Test-Path $filePath) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentType = "text/html; charset=utf-8"
            $response.Headers.Add("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0")
            $response.Headers.Add("Pragma", "no-cache")
            $response.Headers.Add("Expires", "0")
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.OutputStream.Close()
    } catch {
        # continue listening on errors
    }
}
