from FlagEmbedding import BGEM3FlagModel


model = BGEM3FlagModel(
    "BAAI/bge-m3",
    use_fp16=True,
)

texts = [
    "\u60f3\u627e\u4e00\u672c\u9002\u5408\u5165\u95e8\u7684\u5fc3\u7406\u5b66\u4e66\uff0c\u4e0d\u8981\u592a\u5b66\u672f",
    "I want an easy science fiction book like The Three-Body Problem",
]

output = model.encode(
    texts,
    batch_size=2,
    max_length=512,
    return_dense=True,
    return_sparse=False,
    return_colbert_vecs=False,
)

embeddings = output["dense_vecs"]

print(type(embeddings))
print(embeddings.shape)
print(embeddings[0][:10])
