import json
import urllib.request

payload = {
    "query": "books like The Alchemist about personal growth",
    "topN": 2,
    "candidates": [
        {
            "id": 1,
            "title": "The Little Prince",
            "passage": "Title: The Little Prince\nCategory: Fiction\nDescription: A poetic story about wonder, friendship, and seeing life clearly.",
        },
        {
            "id": 2,
            "title": "Database Internals",
            "passage": "Title: Database Internals\nCategory: Computer Science\nDescription: A technical guide to database storage engines.",
        },
    ],
}

data = json.dumps(payload, ensure_ascii=False).encode("utf-8")

request = urllib.request.Request(
    "http://127.0.0.1:8001/rerank",
    data=data,
    headers={"Content-Type": "application/json"},
    method="POST",
)

with urllib.request.urlopen(request, timeout=120) as response:
    result = json.loads(response.read().decode("utf-8"))

print("backend:", result.get("backend"))
print("model:", result.get("model"))
print("topN:", result.get("topN"))
print("elapsedMs:", result.get("elapsedMs"))
print("results:")
for item in result.get("results", []):
    print("  id:", item.get("id"), "score:", item.get("score"), "rank:", item.get("rank"))
