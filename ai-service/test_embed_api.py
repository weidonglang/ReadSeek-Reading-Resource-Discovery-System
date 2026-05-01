import json
import urllib.request

payload = {
    "text": "\u60f3\u627e\u4e00\u672c\u9002\u5408\u5165\u95e8\u7684\u5fc3\u7406\u5b66\u4e66\uff0c\u4e0d\u8981\u592a\u5b66\u672f",
    "model": "BAAI/bge-m3",
    "inputType": "query",
}

data = json.dumps(payload, ensure_ascii=False).encode("utf-8")

request = urllib.request.Request(
    "http://127.0.0.1:8001/embed",
    data=data,
    headers={"Content-Type": "application/json"},
    method="POST",
)

with urllib.request.urlopen(request, timeout=60) as response:
    result = json.loads(response.read().decode("utf-8"))

print("backend:", result.get("backend"))
print("model:", result.get("model"))
print("dimensions:", result.get("dimensions"))
print("vector length:", len(result.get("vector", [])))
print("elapsedMs:", result.get("elapsedMs"))
print("first 5 values:", result.get("vector", [])[:5])
