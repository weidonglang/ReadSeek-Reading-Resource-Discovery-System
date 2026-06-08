# ReadSeek 模型微调开发计划书

> 目标时间：项目暂停 1-2 个月后重新启动时使用。  
> 方向：围绕 ReadSeek 的阅读资源检索任务，尝试微调 reranker 或 embedding 模型，让系统从“使用通用模型”进一步升级为“面向本馆藏领域优化的模型”。

---

## 1. 背景

当前 ReadSeek 已经完成：

- PostgreSQL exact-db 召回。
- Elasticsearch BM25 召回。
- BGE-M3 embedding 向量召回。
- BGE reranker 精排。
- RAG 问答和证据卡片。
- 100 条检索评测、60 条 RAG 问题集、推荐评测和压测。
- `readseek-bench-rs` 离线评测工具。

当前系统的强项是工程闭环完整，但模型本身仍主要使用通用预训练模型。下一阶段可以尝试做领域适配：

- 让 embedding 更理解“阅读资源发现”的查询表达。
- 让 reranker 更适合 ReadSeek 的馆藏、简介、标签和推荐理由。
- 让本地 LLM 更擅长基于馆藏证据回答、引用、拒答和生成阅读路径。
- 用评测报告证明微调前后是否真的提升，而不是只停留在“换了模型”。

---

## 2. 总目标

在不破坏当前系统稳定性的前提下，完成一套可复现的模型微调实验链路：

```text
构造训练数据
  -> 训练意图识别、reranker、embedding、RAG LLM 或推荐理由生成模型
  -> 本地 AI 服务加载新模型
  -> 重建索引或更新 reranker
  -> 用 readseek-bench-rs 对比原模型和微调模型
  -> 输出 Markdown / HTML 报告
```

验收时至少要回答三个问题：

1. 微调 reranker 或 embedding 后，检索排序是否相比原始 BGE 模型提升？
2. 查询意图识别、RAG 生成和推荐理由生成是否服务了“阅读资源发现”主线，而不是变成孤立模块？
3. 提升是否值得付出额外延迟、模型大小和维护成本？

---

## 3. 推荐开发顺序

建议采用：

```text
一个主创新 + 两个辅助创新 + 一个展示创新
```

不要把论文或答辩写成“我微调了四个模型”。更好的写法是：围绕阅读资源发现任务，构建领域数据集，并用微调模型增强检索、问答和推荐解释闭环。

### 3.1 创新点组织

| 层级 | 方向 | 论文定位 | 作用 |
| --- | --- | --- | --- |
| 主创新 | reranker / embedding 微调 | 面向阅读资源检索的领域相关性模型微调 | 直接提升搜索主线，有硬指标证明。 |
| 辅助创新一 | 查询意图识别微调 | 自适应混合检索策略选择 | 服务主创新，让系统知道什么时候用 exact、BM25、vector、hybrid 或 RAG。 |
| 辅助创新二 | RAG 答案生成微调 | 证据约束的领域问答生成 | 提升智能问答的引用准确性、相关性和低幻觉能力。 |
| 展示创新 | 推荐理由生成微调 | 面向用户偏好的推荐解释生成 | 增强前端展示和答辩演示效果。 |

### 3.2 推荐优先级

| 方向 | 优先级 | 原因 |
| --- | --- | --- |
| reranker 微调 | 最高 | 技术含量高；最贴合搜索主线；不需要重建向量索引；Precision@5、MRR、NDCG@10 容易证明效果。 |
| embedding 微调 | 高 | 技术含量同样高；可提升语义召回；但需要重建 Elasticsearch 向量索引，工程风险高于 reranker。 |
| 查询意图识别微调 | 中高 | 数据容易构造；模型小；评测简单；用于驱动自适应混合检索，是检索主创新的辅助模块。 |
| RAG LLM 微调 | 中高 | 展示效果强，可提升回答格式、引用习惯、证据约束和拒答能力；评测复杂度高于意图识别。 |
| 推荐理由生成微调 | 中 | 前端展示直观，适合答辩演示，但技术深度通常弱于检索相关性模型微调。 |
| 同时微调多个模型 | 低 | 变量太多，不利于判断收益，建议最后再做。 |

### 3.3 最推荐的论文创新点写法

不要写成：

```text
创新点一：微调了意图识别模型。
创新点二：微调了 reranker。
创新点三：微调了 RAG。
创新点四：微调了推荐理由生成模型。
```

建议写成：

1. **面向阅读资源发现的领域数据集构建**  
   构建包括查询意图、检索相关性、证据问答、推荐解释在内的多任务数据集，为阅读资源发现系统提供领域适配数据基础。

2. **基于微调模型的自适应混合检索机制**  
   通过查询意图识别模型判断用户需求类型，并结合微调后的向量召回或重排序模型，实现更准确的资源召回与排序。

3. **证据约束的领域 RAG 问答生成方法**  
   基于馆藏资源证据片段构造问答样本，对生成模型进行领域适配，提升答案相关性、引用准确率和可解释性。

4. **面向用户偏好的推荐解释生成**  
   结合用户画像、资源元数据和推荐来源，生成个性化、可解释的推荐理由，提高推荐结果的可理解性和系统体验。

### 3.4 分阶段目标

第一阶段目标：

```text
通用 BGE reranker
  vs
ReadSeek 微调 reranker
```

第二阶段目标：

```text
规则/启发式意图识别
  vs
ReadSeek 查询意图识别模型 v1
```

第三阶段再做：

```text
通用 Qwen 本地模型
  vs
ReadSeek RAG LLM v1
```

第四阶段再做：

```text
通用 BGE-M3 embedding
  vs
ReadSeek 微调 embedding
```

第五阶段可做：

```text
模板/规则推荐理由
  vs
ReadSeek 推荐理由生成模型 v1
```

---

## 4. 数据集设计

### 4.1 数据来源

可用数据来源：

- `docs/evaluation/search_queries_100.json`
- `docs/evaluation/generated/rust-suite/search_queries_100_resolved.json`
- `docs/evaluation/rag_questions_60.json`
- 图书标题、作者、分类、标签、简介、AI 补全的 `search_keywords` 和 `recommendation_reason`
- 用户行为日志：搜索、点击、借阅、评分、推荐反馈
- RAG 证据命中结果
- 人工补充的查询和相关图书标注

### 4.2 训练样本类型

建议维护三类数据：

#### Query-Positive-Negative

用于 embedding 或 reranker：

```jsonl
{"query":"爱情小说 推荐","positive_id":400,"negative_ids":[151,302,24],"source":"search_queries_100","split":"train"}
```

#### Pairwise Reranker

用于 reranker：

```jsonl
{"query":"爱情小说 推荐","positive_text":"Pride and Prejudice ...","negative_text":"The Art of Computer Programming ...","label":1}
```

#### Scored Passage

用于更精细的排序训练：

```jsonl
{"query":"科幻小说入门","passage":"The War of the Worlds ...","score":3}
{"query":"科幻小说入门","passage":"A History of Mathematics ...","score":0}
```

### 4.3 数据目录建议

建议新增目录：

```text
model-training/
├── README.md
├── datasets/
│   ├── query_intent_v1.jsonl
│   ├── retrieval_pairs_v1.jsonl
│   ├── reranker_pairs_v1.jsonl
│   ├── embedding_triples_v1.jsonl
│   ├── rag_sft_v1.jsonl
│   ├── recommendation_reason_sft_v1.jsonl
│   ├── rag_preference_v1.jsonl
│   └── qrels_v1.csv
├── scripts/
│   ├── build_intent_dataset.py
│   ├── build_training_dataset.py
│   ├── mine_hard_negatives.py
│   ├── train_intent_classifier.py
│   ├── train_reranker.py
│   ├── train_embedding.py
│   ├── build_rag_sft_dataset.py
│   ├── train_rag_lora.py
│   ├── train_recommendation_reason_lora.py
│   └── export_model.py
├── configs/
│   ├── intent_classifier_v1.yaml
│   ├── reranker_bge_v1.yaml
│   ├── embedding_bge_m3_v1.yaml
│   ├── rag_llm_qwen_lora_v1.yaml
│   └── recommendation_reason_lora_v1.yaml
└── outputs/
    ├── readseek-intent-classifier-v1/
    ├── readseek-reranker-v1/
    ├── readseek-embedding-v1/
    ├── readseek-rag-llm-v1/
    └── readseek-recommendation-reason-v1/
```

`outputs/` 不建议上传大模型文件到 GitHub，可以只上传配置、训练日志摘要和评测报告。

下面的详细方案按系统链路展开，不代表优先级。实际开发和论文主线以第 3 节为准：reranker / embedding 是主创新，查询意图识别、RAG 生成和推荐理由生成服务于主线。

---

## 5. 查询意图识别微调方案

### 5.1 目标

训练一个轻量查询意图识别模型，判断用户查询属于哪类阅读资源发现任务，并据此动态选择检索策略。

建议项目名称：

```text
面向阅读资源发现的查询意图识别微调模型与自适应混合检索策略
```

这个方向最稳，因为它贴合当前系统主线：

- exact-db 适合精确书名。
- BM25 适合关键词和作者。
- vector 适合自然语言、主题和学习目标。
- hybrid 适合混合需求。
- reranker 适合需要高质量排序的推荐、比较和问答场景。

### 5.2 意图标签

建议先定义 8 类：

| 标签 | 说明 | 推荐检索策略 |
| --- | --- | --- |
| `EXACT_TITLE` | 精确查书名 | exact-db + BM25 |
| `AUTHOR_WORKS` | 查作者或作者作品 | exact-db + BM25 |
| `THEME_TOPIC` | 查主题、类型、标签 | vector + BM25 + hybrid |
| `LEARNING_GOAL` | 学习目标或阅读路径 | vector + hybrid + reranker |
| `SIMILAR_BOOK` | 找相似书 | similar recommendation + vector |
| `RECOMMENDATION` | 找书、推荐、排行 | hybrid + reranker + recommendation |
| `QA` | 问答型问题 | RAG hybrid + reranker |
| `METADATA_FILTER` | ISBN、出版社、分类等元数据过滤 | exact-db + BM25 fallback |

### 5.3 数据格式

```jsonl
{"query":"Pride and Prejudice","label":"EXACT_TITLE","source":"search_queries_100","split":"train"}
{"query":"Jane Austen 有哪些代表作","label":"AUTHOR_WORKS","source":"manual","split":"train"}
{"query":"适合入门的爱情小说","label":"RECOMMENDATION","source":"rag_questions_60","split":"train"}
{"query":"我想从零开始学数学，先读哪几本？","label":"LEARNING_GOAL","source":"manual","split":"dev"}
{"query":"这本书适合考研复习吗？","label":"QA","source":"manual","split":"test"}
```

### 5.4 数据构造方式

来源：

- `search_queries_100.json` 的 `intent` 字段。
- `rag_questions_60.json` 的问题类型。
- 前端搜索日志。
- AI Chat 历史。
- 人工扩写 query。

建议每类至少准备：

- MVP：30-50 条。
- v1：100-200 条。
- v2：300+ 条。

注意每类都要包含中文、英文、短查询、长查询和口语化表达。

### 5.5 模型选择

优先使用轻量模型，不需要大模型：

| 模型 | 建议 |
| --- | --- |
| `sentence-transformers` + logistic regression | 最快 MVP，可解释性强 |
| `distilbert-base-multilingual-cased` | 轻量多语言分类 |
| `bge-m3 embedding + MLP classifier` | 复用现有 embedding 服务 |
| 小 Qwen LoRA | 可做，但没必要作为第一版 |

MVP 推荐：

```text
BGE-M3 query embedding -> lightweight classifier
```

这样可以复用现有 `ai-service/server_bge_m3.py`，不需要单独部署大模型分类服务。

### 5.6 接入方式

后端当前已有查询意图和策略字段。下一步可以新增：

```text
IntentClassifierService
AdaptiveSearchStrategyService
```

流程：

```text
User query
  -> IntentClassifierService
  -> predicted intent + confidence
  -> AdaptiveSearchStrategyService
  -> choose exact / BM25 / vector / hybrid / reranker / RAG
  -> SearchController response includes intent source and confidence
```

低置信度处理：

- confidence >= 0.75：使用模型预测策略。
- 0.45 <= confidence < 0.75：模型预测 + 规则兜底。
- confidence < 0.45：回退当前启发式策略。

### 5.7 评测指标

分类指标：

- Accuracy
- Macro F1
- Per-class F1
- Confusion matrix

系统指标：

- 自适应策略 vs 固定 hybrid_reranker 的 Precision@5、MRR、NDCG@10。
- 平均延迟是否下降。
- 低成本查询是否避免不必要 reranker。
- QA 问题是否正确进入 RAG。

### 5.8 验收标准

MVP 验收：

- 意图分类 Macro F1 >= 0.80。
- 至少 6 类意图可稳定识别。
- 自适应策略延迟低于全量 hybrid_reranker。
- 检索效果不明显下降。
- 搜索响应中能展示预测意图、置信度和选择的策略。

---

## 6. Reranker 微调方案

### 6.1 目标

让 reranker 更适合 ReadSeek 的领域相关性判断。

例如：

- 用户问“爱情小说”，浪漫小说、Jane Austen、Jojo Moyes 应该排前。
- 用户问“Java 系统设计”，编程、系统、软件工程相关资源应优先。
- 用户问“数学入门阅读顺序”，数学史、素数、算法数学相关资源应优先。
- 用户问“恐怖小说入门”，Horror 类别和简介里有恐怖元素的书应优先。

### 6.2 训练数据构造

每条 query 至少构造：

- 1-5 个正样本。
- 5-20 个负样本。
- 其中至少 2-5 个 hard negatives。

hard negative 来源：

- BM25 排名前列但实际不相关。
- vector 排名前列但语义偏移。
- 同分类但主题不匹配的书。
- 标题相似但作者或主题不对的书。

### 6.3 训练方法

可选技术路线：

- 基于 `BAAI/bge-reranker-v2-m3` 做微调。
- 使用 FlagEmbedding 或 sentence-transformers cross-encoder 训练。
- 输入为 `(query, passage)`。
- 输出为相关性分数。

passage 拼接建议：

```text
Title: {title}
Author: {author}
Category: {category}
Tags: {tags}
Description: {description}
Keywords: {search_keywords}
Recommendation reason: {recommendation_reason}
```

### 6.4 接入方式

训练完成后：

1. 导出模型到本地目录，例如：

```text
models/readseek-reranker-v1/
```

2. 修改 AI 服务配置，让 `server_bge_m3.py` 支持通过环境变量指定 reranker 模型路径：

```text
READSEEK_RERANKER_MODEL=models/readseek-reranker-v1
```

3. 不需要重建 Elasticsearch 向量索引。
4. 直接运行 `readseek-bench-rs` 对比：

```text
original-bge-reranker
vs
readseek-reranker-v1
```

### 6.5 验收指标

在 100 条检索评测上，目标是至少满足其中两项：

- `hybrid_reranker` Precision@5 提升。
- MRR 提升。
- NDCG@10 提升。
- 中文主题查询和自然语言查询分组指标提升。
- 延迟增加不超过 30%。

如果指标下降或延迟明显变差，应保留原始 BGE reranker 作为默认模型。

---

## 7. Embedding 微调方案

### 7.1 目标

让向量召回更适合 ReadSeek 的查询和馆藏表达。

重点提升：

- 中文自然语言查询。
- 主题查询。
- 阅读路径查询。
- 查询词和书籍简介表述不一致的场景。

### 7.2 训练数据构造

embedding 微调需要三元组：

```text
query, positive_passage, negative_passage
```

数据来源：

- `search_queries_100_resolved.json` 中 resolved relevant ids。
- 用户搜索后点击或借阅的书作为正样本。
- BM25/vector 返回但未点击、未命中的书作为负样本。
- RAG 中被引用的证据作为正样本。

### 7.3 训练方法

可选路线：

- 基于 `BAAI/bge-m3` 做对比学习微调。
- 优先做 LoRA 或小规模 adapter 微调，降低显存需求。
- 初期不要改 embedding 维度，保持 1024 维，减少后端和 Elasticsearch 改动。

### 7.4 接入方式

embedding 微调完成后：

1. 导出模型到：

```text
models/readseek-embedding-v1/
```

2. 修改 AI 服务 embedding 模型路径：

```text
READSEEK_EMBEDDING_MODEL=models/readseek-embedding-v1
```

3. 必须重建资源索引：

```text
POST /api/search/index/resources/rebuild
```

4. 重新跑四组检索评测：

```text
bm25
vector
hybrid
hybrid_reranker
```

### 7.5 验收指标

重点看：

- vector Precision@5
- vector Recall@5
- vector NDCG@10
- hybrid Recall@5
- natural-cn、theme-cn、reading-path 分组指标

如果 vector 指标提升但 hybrid_reranker 下降，需要分析是否 embedding 召回引入了更多噪声。

---

## 8. RAG LLM 微调方案

### 8.1 目标

LLM 微调的目标不是提升检索召回，也不是让大模型记住全部馆藏。

正确目标是让本地大模型更适合作为 ReadSeek 的 RAG 答案生成器：

- 更稳定地基于给定证据回答。
- 更规范地使用引用编号，例如 `[1]`、`[2]`。
- 证据不足时能保守拒答。
- 更擅长生成书籍对比、推荐理由和阅读路径。
- 降低使用馆藏外事实自由发挥的倾向。
- 让回答风格更适合中文阅读推荐场景。

不要把 LLM 微调目标写成：

```text
让大模型记住所有书籍知识
```

因为馆藏会变化，图书详情、标签、简介和推荐理由都应该来自数据库、搜索索引和 RAG 证据。

### 8.2 适合训练的能力

| 能力 | 是否适合微调 | 说明 |
| --- | --- | --- |
| 引用格式 | 适合 | 让模型稳定输出 `[1] [2]`，并避免无引用结论。 |
| 证据约束 | 适合 | 训练模型只根据 evidence 回答。 |
| 证据不足拒答 | 适合 | 避免编造不存在的馆藏。 |
| 推荐理由表达 | 适合 | 提升输出可读性和答辩展示效果。 |
| 阅读路径生成 | 适合 | 训练“从入门到进阶”的排序话术。 |
| 记忆全部馆藏 | 不适合 | 馆藏应由检索系统提供，不应硬塞进模型权重。 |
| 提升向量召回 | 不适合 | 这是 embedding 微调的目标。 |
| 提升候选排序 | 不适合 | 这是 reranker 微调的目标。 |

### 8.3 训练数据格式

建议使用 SFT JSONL：

```jsonl
{"messages":[{"role":"system","content":"你是 ReadSeek 阅读助手。必须优先基于给定馆藏证据回答，不能使用证据外事实。回答中需要使用 [1] [2] 形式引用证据。"},{"role":"user","content":"问题：帮我推荐几本爱情小说，并说明推荐顺序。\n\n证据：\n[1] Pride and Prejudice｜Jane Austen｜Romantic｜经典浪漫小说...\n[2] Sense and Sensibility｜Jane Austen｜Romantic｜理性与情感..."},{"role":"assistant","content":"可以按以下顺序阅读：\n\n1. Pride and Prejudice [1]\n   理由：...\n\n2. Sense and Sensibility [2]\n   理由：...\n\n以上推荐仅基于当前馆藏证据。"}]}
```

也可以准备 preference 数据，用于后续 DPO：

```jsonl
{"prompt":"问题和证据...","chosen":"带引用、保守、准确的回答","rejected":"无引用、编造、过度泛化的回答"}
```

### 8.4 数据来源

可从现有系统生成：

- `docs/evaluation/rag_questions_60.json`
- `docs/evaluation/generated/rust-suite/rag_results.json`
- RAG 证据卡片。
- AI Chat 历史。
- 人工改写后的高质量答案。
- 失败案例中的反例回答。

建议数据规模：

| 阶段 | 样本量 | 目标 |
| --- | ---: | --- |
| smoke | 30-50 | 跑通训练和加载流程 |
| v1 | 200-500 | 初步学习引用、拒答和回答格式 |
| v2 | 1000+ | 更稳定的回答风格和多任务能力 |

### 8.5 模型选择

优先从小模型做 LoRA / QLoRA：

| 模型 | 建议 |
| --- | --- |
| qwen2.5:7b | 首选，速度和成本较平衡 |
| qwen3:8b | 可作为第二选择 |
| qwen3:14b | 不建议一开始微调，成本高，适合作为对照或后期版本 |
| qwen2.5-coder:7b | 不建议用于 RAG 回答微调，它更适合报告 HTML 生成 |

### 8.6 训练方法

建议路线：

1. SFT 先行：训练引用格式、回答结构、拒答规则。
2. 人工审核：抽查回答是否真的受证据约束。
3. 需要时再做 DPO：用 chosen/rejected 强化“引用正确、拒绝编造”的偏好。

训练配置建议：

- LoRA rank 从 8 或 16 开始。
- 学习率保守，避免过拟合。
- 保留验证集。
- 不要把验证集问题放进训练集。
- 先训练 1-3 epoch，观察格式和幻觉变化。

### 8.7 接入方式

训练完成后导出：

```text
models/readseek-rag-llm-v1/
```

接入方式有两种：

#### 方案 A：转换后由 Ollama 加载

适合继续沿用当前后端配置。

需要：

- 将 LoRA 合并或转换成 Ollama 可加载模型。
- 新建 Ollama Modelfile。
- 创建模型名，例如：

```text
readseek-rag-qwen2.5-7b:v1
```

然后修改：

```text
RAG_STANDARD_MODEL=readseek-rag-qwen2.5-7b:v1
```

#### 方案 B：独立 LLM API 服务

适合后续做更灵活的模型管理。

需要：

- 新增本地 OpenAI-compatible inference server。
- 后端走 `ONLINE_AI_BASE_URL` 或新增 provider。
- 可以更方便地切换 base model、LoRA adapter 和量化版本。

MVP 建议优先方案 A。

### 8.8 评测指标

LLM 微调不主要看 Precision@5。应重点看：

- Citation coverage：回答中引用覆盖率。
- Citation validity：引用是否真的支持回答。
- Hallucination risk：是否引入证据外事实。
- Refusal correctness：证据不足时是否拒答。
- Answer completeness：回答是否完整。
- Answer structure：格式是否稳定。
- Average total latency：是否明显变慢。

可继续使用 `rag_evaluation_manual_scoring.csv`，补充人工评分。

### 8.9 验收标准

LLM 微调 v1 至少满足：

- 引用格式明显更稳定。
- 人工抽查中幻觉风险下降。
- 证据不足问题更倾向于保守拒答。
- 回答可读性提升。
- 平均延迟没有明显不可接受增长。

如果只是回答更长、更像作文，但引用不准或证据约束变差，则不应采用微调 LLM 作为默认模型。

---

## 9. 推荐理由生成微调方案

### 9.1 目标

推荐理由生成微调不作为核心算法贡献，而作为前端展示和用户体验增强。

目标是让系统能根据用户画像、资源元数据和推荐来源，生成更自然、更个性化、更有解释力的推荐理由。

示例：

```text
微调前：这本书很适合你。

微调后：你近期关注机器学习与 Python 实践，本书包含算法原理和项目案例，适合作为进阶阅读资源。
```

### 9.2 输入输出格式

```jsonl
{"messages":[{"role":"system","content":"你是 ReadSeek 推荐解释生成器。根据用户画像、图书信息和推荐来源生成简洁、具体、可信的中文推荐理由。"},{"role":"user","content":"用户画像：关注人工智能、数据结构、Python 实践。\n图书：Machine Learning with Python。\n分类：Computer Science。\n推荐来源：相似主题 + 用户近期搜索。\n候选理由：命中人工智能和 Python 标签。"},{"role":"assistant","content":"这本书适合你，因为你近期关注人工智能和 Python 实践，本书结合机器学习原理与代码案例，适合作为从理论过渡到项目实践的进阶阅读资源。"}]}
```

### 9.3 数据来源

- 推荐 overview 和 similar recommendation 结果。
- 用户搜索、点击、评分、借阅和反馈日志。
- 图书标题、分类、标签、简介、推荐理由。
- 人工改写的高质量推荐解释。

### 9.4 接入方式

推荐理由生成可以有两种使用方式：

1. 离线生成：批量为推荐结果生成理由，缓存到数据库或报告中。
2. 在线生成：前端请求推荐时实时生成，适合少量重点推荐卡片。

MVP 建议先做离线生成，避免在线延迟影响推荐页体验。

### 9.5 评测指标

- 人工相关性评分。
- 个性化程度评分。
- 解释具体性评分。
- 是否引用了真实用户偏好或真实推荐来源。
- 是否出现无法由元数据支持的夸张表述。

### 9.6 验收标准

- 推荐理由比模板更具体。
- 不编造用户偏好。
- 不编造图书内容。
- 前端展示效果明显更好。
- 不作为检索效果提升的主要证据，只作为体验增强。

---

## 10. 评测设计

### 10.1 必须保留基线

每次训练前，先保存原始结果：

```text
baseline-bge-m3
baseline-bge-reranker
baseline-qwen-rag
```

不要只保存微调后的结果。

### 10.2 推荐实验分组

| 实验组 | Embedding | Reranker | 目的 |
| --- | --- | --- | --- |
| A | BGE-M3 原始 | BGE reranker 原始 | 当前系统基线 |
| B | BGE-M3 原始 | ReadSeek reranker v1 | 验证 reranker 微调收益 |
| C | ReadSeek embedding v1 | BGE reranker 原始 | 验证 embedding 微调收益 |
| D | ReadSeek embedding v1 | ReadSeek reranker v1 | 验证组合收益 |

LLM 单独实验：

| 实验组 | Retriever/Reranker | LLM | 目的 |
| --- | --- | --- | --- |
| L0 | 当前默认检索链路 | 原始 Qwen | 当前 RAG 生成基线 |
| L1 | 当前默认检索链路 | ReadSeek RAG LLM v1 | 验证回答格式、引用和拒答能力 |
| L2 | 微调 reranker | ReadSeek RAG LLM v1 | 验证检索排序和生成模型组合效果 |

### 10.3 指标

检索指标：

- Precision@5
- Recall@5
- MRR
- NDCG@10
- Avg latency
- P95 latency

RAG 指标：

- Evidence hit rate
- Mean evidence recall
- Citation coverage
- Answerable rate
- Average total latency
- 人工评分：relevance、completeness、citation validity、hallucination risk
- 拒答正确率
- 引用格式合规率
- 证据外事实比例

推荐相关观察：

- 推荐结果是否更贴近查询意图。
- 相似推荐是否更稳定。
- 推荐理由是否更容易被 RAG 引用。
- 推荐理由是否更个性化、具体且不编造事实。

### 10.4 报告输出

继续使用：

```powershell
.\scripts\run_readseek_bench_rs_suite.ps1
```

建议新增输出目录：

```text
docs/evaluation/generated/finetune-baseline/
docs/evaluation/generated/finetune-reranker-v1/
docs/evaluation/generated/finetune-rag-llm-v1/
docs/evaluation/generated/finetune-embedding-v1/
docs/evaluation/generated/finetune-recommendation-reason-v1/
docs/evaluation/generated/finetune-combined-v1/
```

最终报告应包含：

- 指标对比表。
- 分查询类型对比。
- 成功案例。
- 失败案例。
- 延迟变化。
- 是否建议替换默认模型。

---

## 11. 两个月开发路线

### 第 1 周：恢复环境和确认基线

任务：

- 启动完整 ReadSeek 服务。
- 确认 BGE-M3 AI 服务可用。
- 重建资源索引。
- 跑一次完整 Rust suite。
- 保存 baseline 报告。

产出：

- `docs/evaluation/generated/finetune-baseline/`
- baseline 指标表。

验收：

- 当前 README 中的指标能复现或差异可解释。

### 第 2 周：构造训练数据

任务：

- 写 `build_intent_dataset.py` 和 `build_training_dataset.py`。
- 从搜索查询、RAG 问题和人工扩写样本构造 `query_intent_v1.jsonl`。
- 从 100 查询集和 resolved qrels 生成 query-positive-negative。
- 从 BM25/vector/hybrid 结果中挖 hard negatives。
- 从 RAG 问题和回答结果构造 `rag_sft_v1.jsonl`。
- 从推荐结果和人工改写样本构造 `recommendation_reason_sft_v1.jsonl`。
- 人工抽查至少 100 条样本。

产出：

- `query_intent_v1.jsonl`
- `retrieval_pairs_v1.jsonl`
- `reranker_pairs_v1.jsonl`
- `rag_sft_v1.jsonl`
- `recommendation_reason_sft_v1.jsonl`
- `qrels_v1.csv`

验收：

- 每个意图类别都有样本。
- 每条 query 有正负样本。
- 没有明显错误正样本。
- hard negatives 不是随机垃圾数据。

### 第 3 周：意图识别模型和自适应检索策略

任务：

- 训练轻量查询意图识别模型。
- 在后端接入 `IntentClassifierService`。
- 根据意图和置信度选择 exact、BM25、vector、hybrid、reranker 或 RAG。
- 在搜索响应中展示预测意图、置信度和策略来源。
- 与当前启发式策略对比。

产出：

- `models/readseek-intent-classifier-v1/`
- `docs/evaluation/generated/finetune-intent-v1/`

验收：

- Macro F1 达到可接受水平。
- QA、推荐、精确查书、主题检索等主要类别能稳定区分。
- 自适应策略没有明显降低检索效果。
- 部分简单查询能减少不必要 reranker 延迟。

### 第 4-5 周：主创新，微调 reranker

任务：

- 搭建训练脚本。
- 用小数据先跑通训练。
- 导出 `readseek-reranker-v1`。
- 修改 AI 服务支持加载本地 reranker。
- 跑检索评测。
- 重点比较 rerank 前后排序变化。

产出：

- `models/readseek-reranker-v1/`
- `docs/evaluation/generated/finetune-reranker-v1/`

验收：

- `hybrid_reranker` 至少一个核心排序指标提升。
- 延迟变化可接受。
- 原始 reranker 可一键回退。

### 第 6 周：补充 embedding 或 RAG LLM 实验

任务：

- 如果 reranker 指标提升明显，优先尝试 embedding 微调。
- 如果答辩更需要展示智能问答效果，优先尝试 RAG LLM 微调。
- embedding 路线：构造 triples、微调 BGE-M3、重建索引、跑检索评测。
- RAG LLM 路线：构造 SFT 数据、微调 `qwen2.5:7b` 或 `qwen3:8b`、跑 RAG 评测。

产出：

- `models/readseek-embedding-v1/` 或 `models/readseek-rag-llm-v1/`
- `docs/evaluation/generated/finetune-embedding-v1/` 或 `docs/evaluation/generated/finetune-rag-llm-v1/`

验收：

- embedding 路线：vector/hybrid 指标提升且没有明显退化。
- RAG LLM 路线：引用格式更稳定，幻觉风险不升高。

### 第 7 周：推荐理由生成和人工评估

任务：

- 训练或调用轻量推荐理由生成模型。
- 抽取 20-30 个检索和推荐案例做人工对比。
- 标注微调前后哪个排序更合理。
- 标注推荐理由是否更具体、更个性化。
- 记录失败类型。

产出：

- `models/readseek-recommendation-reason-v1/`
- `docs/evaluation/generated/finetune-recommendation-reason-v1/`
- `manual_reranker_review_v1.csv`
- `manual_rag_llm_review_v1.csv`
- `manual_recommendation_reason_review_v1.csv`

验收：

- 有明确结论：继续、回退或补数据再训练。
- 推荐理由展示效果明显优于模板。

### 第 8 周：组合实验和总结

任务：

- 跑 A/B/C/D 检索实验。
- 跑 L0/L1/L2 RAG LLM 实验。
- 跑意图识别自适应检索实验。
- 跑推荐理由人工评分。
- 生成最终对比报告。
- 更新 README、AI service README、evaluation README。
- 写清楚是否采用微调模型作为默认模型。

产出：

- `docs/model-finetuning-report-v1.md`
- `docs/evaluation/generated/finetune-comparison/`

验收：

- 有清晰结论。
- 有可复现命令。
- 有失败案例和限制说明。

---

## 12. 最小可行版本

如果时间有限，只做 MVP：

1. 主创新只做 reranker 微调。
2. 辅助创新只做查询意图识别，不做 embedding。
3. 展示创新只做少量推荐理由生成样例。
4. reranker 只使用 100 条 search queries 和 resolved qrels。
5. 意图识别只使用搜索查询、RAG 问题和人工扩写样本。
6. RAG LLM 可作为可选项，不作为 MVP 必做。
7. reranker 只对比：

```text
BGE reranker
vs
ReadSeek reranker v1
```

8. 意图识别只对比：

```text
启发式规则
vs
ReadSeek intent classifier v1
```

9. 可选 RAG LLM 对比：

```text
原始 Qwen
vs
ReadSeek RAG LLM v1
```

7. 只要求输出一份 Markdown 对比报告。

MVP 验收：

- 训练脚本能跑通。
- 意图识别模型能输出类别和置信度。
- AI 服务能加载微调 reranker。
- `hybrid_reranker` 指标有对比结果。
- 自适应检索策略有延迟或效果对比。
- 推荐理由有前端展示样例。
- 原始模型可回退。

---

## 13. 风险和注意事项

### 数据规模不足

当前馆藏和查询规模较小，微调可能过拟合。

应对：

- 保留验证集。
- 做分 intent 指标。
- 不要只看总平均分。
- 人工检查失败案例。

### 伪标签质量不稳定

如果正负样本主要来自自动规则，可能把原系统偏差学进去。

应对：

- 抽样人工审核。
- 保留 hard negatives。
- 对高风险样本降低权重或不用于训练。

### embedding 微调成本较高

embedding 改动需要重建索引，排查成本高。

应对：

- 先做 reranker。
- embedding 保持 1024 维。
- 保存原始索引配置和回退方案。

### LLM 微调学会编造格式化答案

LLM 可能学会更漂亮的回答格式，但并没有更好地遵守证据。

应对：

- 不只看回答流畅度。
- 必须人工检查 citation validity 和 hallucination risk。
- 构造证据不足的拒答样本。
- 不把馆藏知识硬塞进模型，馆藏事实仍以 RAG 证据为准。

### 意图识别过度影响检索结果

如果意图识别错了，可能把查询送到错误策略，导致检索结果变差。

应对：

- 使用置信度阈值。
- 低置信度回退 hybrid。
- 保留启发式规则作为 fallback。
- 在评测中单独统计错误意图导致的失败案例。

### 推荐理由生成过度拟合话术

推荐理由模型可能只学会漂亮模板，而不是基于真实用户偏好。

应对：

- 输入中明确给出用户画像、推荐来源和图书元数据。
- 人工检查是否编造用户偏好。
- 推荐理由生成不作为核心检索效果指标。

### 指标提升但体验不提升

离线指标可能提升，但实际问答体验变化不明显。

应对：

- 增加人工 case review。
- 增加 RAG evidence hit 和 citation coverage 对比。
- 保留真实问答截图或报告片段。

---

## 14. 开发任务清单

### 数据

- [ ] 新建 `model-training/` 目录。
- [ ] 编写训练数据构造脚本。
- [ ] 构造 `query_intent_v1.jsonl`。
- [ ] 从 resolved qrels 构造正负样本。
- [ ] 挖掘 hard negatives。
- [ ] 构造 `recommendation_reason_sft_v1.jsonl`。
- [ ] 建立人工审核 CSV。

### Intent Classifier

- [ ] 编写 `build_intent_dataset.py`。
- [ ] 编写 `train_intent_classifier.py`。
- [ ] 导出 `readseek-intent-classifier-v1`。
- [ ] 后端新增 `IntentClassifierService`。
- [ ] 后端新增 `AdaptiveSearchStrategyService`。
- [ ] 在搜索响应中展示意图、置信度和策略来源。
- [ ] 跑启发式规则 vs 微调意图模型对比实验。

### Reranker

- [ ] 编写 reranker 训练配置。
- [ ] 跑通小样本训练。
- [ ] 导出 `readseek-reranker-v1`。
- [ ] 修改 AI 服务支持加载本地 reranker 路径。
- [ ] 跑 baseline vs finetuned reranker 评测。

### Embedding

- [ ] 构造 embedding triples。
- [ ] 跑通小规模 embedding 微调。
- [ ] 导出 `readseek-embedding-v1`。
- [ ] 重建 Elasticsearch 资源索引。
- [ ] 对比 vector/hybrid 指标。

### RAG LLM

- [ ] 编写 `build_rag_sft_dataset.py`。
- [ ] 从 RAG 结果和人工答案构造 `rag_sft_v1.jsonl`。
- [ ] 构造证据不足拒答样本。
- [ ] 编写 `train_rag_lora.py`。
- [ ] 导出 `readseek-rag-llm-v1`。
- [ ] 接入 Ollama 或本地 OpenAI-compatible inference server。
- [ ] 跑 L0/L1/L2 RAG 对比实验。
- [ ] 填写 `manual_rag_llm_review_v1.csv`。

### Recommendation Reason

- [ ] 编写 `train_recommendation_reason_lora.py`。
- [ ] 导出 `readseek-recommendation-reason-v1`。
- [ ] 支持离线生成推荐理由。
- [ ] 在前端或报告中展示微调前后推荐理由对比。
- [ ] 填写 `manual_recommendation_reason_review_v1.csv`。

### 评测

- [ ] 扩展 `readseek-bench-rs` 支持模型标签参数。
- [ ] 按实验组输出不同目录。
- [ ] 增加查询意图识别分类报告。
- [ ] 生成 Markdown 对比报告。
- [ ] 生成静态 HTML 对比页面。
- [ ] 写失败案例分析。

### 文档

- [ ] 更新 `README.md` 的后续开发说明。
- [ ] 更新 `ai-service/README.md` 的模型加载说明。
- [ ] 新增 `docs/model-finetuning-report-v1.md`。
- [ ] 记录最终是否采用微调模型作为默认配置。

---

## 15. 最终交付标准

微调阶段完成时，至少应交付：

- 一份训练数据说明。
- 一个可复现训练脚本。
- 一个主创新模型：微调 reranker 或 embedding。
- 一个辅助创新模型：查询意图识别模型。
- 一个可选增强模型：RAG LLM 或推荐理由生成模型。
- 一套 baseline vs finetuned 评测结果。
- 一份模型是否值得上线的结论。
- 一个可回退到原始 BGE 模型的配置。

建议最终结论格式：

```text
ReadSeek reranker v1 在 100 条检索评测上相比原始 BGE reranker：
- Precision@5: +x.xx
- MRR: +x.xx
- NDCG@10: +x.xx
- P95 latency: +x ms

结论：建议/不建议作为默认 reranker。
原因：……
```

LLM 微调结论格式：

```text
ReadSeek RAG LLM v1 相比原始 Qwen：
- Citation coverage: +x.xx
- Citation validity manual score: +x.xx
- Hallucination risk manual score: -x.xx
- Refusal correctness: +x.xx
- Average latency: +x ms

结论：建议/不建议作为默认 RAG generation model。
原因：……
```

意图识别结论格式：

```text
ReadSeek intent classifier v1 相比启发式规则：
- Accuracy: +x.xx
- Macro F1: +x.xx
- QA intent F1: +x.xx
- Recommendation intent F1: +x.xx
- Adaptive search avg latency: -x ms
- Retrieval NDCG@10 change: +x.xx

结论：建议/不建议作为默认 query intent model。
原因：……
```

推荐理由生成结论格式：

```text
ReadSeek recommendation reason v1 相比模板理由：
- Manual relevance score: +x.xx
- Personalization score: +x.xx
- Specificity score: +x.xx
- Unsupported claim rate: -x.xx

结论：建议/不建议用于前端推荐卡片展示。
原因：……
```

---

## 16. 接手时第一件事

如果 1-2 个月后重新打开项目，先不要直接训练模型。

第一步应该是：

```powershell
.\start-readseek.bat
.\scripts\run_readseek_bench_rs_suite.ps1 -RetrievalQueryLimit 20 -RagQuestionLimit 8 -LoadRequests 40 -LoadConcurrency 4
```

确认系统还能稳定运行，再恢复完整 baseline。只有 baseline 稳定后，微调实验才有意义。
