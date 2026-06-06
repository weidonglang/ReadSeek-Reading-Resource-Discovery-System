#!/usr/bin/env python3
from __future__ import annotations

from readseek_eval_common import write_json


SEARCH_QUERIES = [
    ("q001", "Pride and Prejudice", "exact-title", ["Pride and Prejudice"], [], [], ["romantic"], ["Jane Austen"]),
    ("q002", "Sense and Sensibility", "exact-title", ["Sense and Sensibility"], [], [], ["romantic"], ["Jane Austen"]),
    ("q003", "The War of the Worlds", "exact-title", ["The War of the Worlds"], [], [], ["science fiction"], ["H. G. Wells"]),
    ("q004", "The Invisible Man", "exact-title", ["The Invisible Man"], [], [], ["science fiction", "horror"], ["H. G. Wells"]),
    ("q005", "Player Piano", "exact-title", ["Player Piano"], [], [], ["science fiction"], ["Kurt Vonnegut"]),
    ("q006", "The Every", "exact-title", ["The Every"], [], [], ["science fiction", "dystopia"], ["Dave Eggers"]),
    ("q007", "The Book of Sand", "exact-title", ["The Book of Sand"], [], [], ["science fiction"], []),
    ("q008", "The Chalk Man", "exact-title", ["The Chalk Man"], [], [], ["horror", "thriller"], []),
    ("q009", "The Year of the Witching", "exact-title", ["The Year of the Witching"], [], [], ["horror"], []),
    ("q010", "The Power of Habit", "exact-title", ["The Power of Habit"], [], [], ["self-help", "habit"], []),
    ("q011", "Jane Austen representative works", "author-work", ["Pride and Prejudice", "Sense and Sensibility"], ["Jane Austen"], ["Romantic"], ["classic romance"]),
    ("q012", "H. G. Wells science fiction", "author-work", ["The War of the Worlds", "The Invisible Man"], ["H. G. Wells"], ["Science Fiction"], ["classic science fiction"]),
    ("q013", "Dave Eggers technology monopoly", "author-work", ["The Every"], ["Dave Eggers"], ["Science Fiction"], ["technology monopoly", "dystopia"]),
    ("q014", "Kurt Vonnegut automation society", "author-work", ["Player Piano"], ["Kurt Vonnegut"], ["Science Fiction"], ["automation", "dystopia"]),
    ("q015", "Jojo Moyes romantic books", "author-work", ["The Giver of Stars"], ["Jojo Moyes"], ["Romantic"], ["love", "community"]),
    ("q016", "Horror books by C. J. Tudor", "author-work", ["The Chalk Man"], ["C. J. Tudor"], ["Horror"], ["suspense"]),
    ("q017", "Doctor Who adventure science fiction", "author-work", ["Doctor Who: Molten Heart"], ["Una McCormack"], ["Science Fiction"], ["Doctor Who", "adventure"]),
    ("q018", "Star Wars Han Solo novel", "author-work", ["A Star Wars Story"], ["Mur Lafferty"], ["Science Fiction"], ["Star Wars", "Han Solo"]),
    ("q019", "Mary Shelley gothic science fiction", "author-work", [], ["Mary Shelley"], ["Science Fiction", "Horror"], ["gothic", "classic"]),
    ("q020", "Oscar Wilde classic literature", "author-work", [], ["Oscar Wilde"], ["Classic"], ["aestheticism", "classic"]),
    ("q021", "爱情小说 推荐", "theme-cn", ["Pride and Prejudice", "Sense and Sensibility", "The Giver of Stars", "Mix Tape", "Live a Little"], [], ["Romantic"], ["爱情", "浪漫", "love", "romance"]),
    ("q022", "经典浪漫主义小说", "theme-cn", ["Pride and Prejudice", "Sense and Sensibility"], [], ["Romantic", "Classic"], ["经典", "爱情", "romance"]),
    ("q023", "科幻小说 入门", "theme-cn", ["The War of the Worlds", "The Invisible Man", "Player Piano", "The Every"], [], ["Science Fiction"], ["科幻", "science fiction"]),
    ("q024", "反乌托邦 科技垄断 小说", "theme-cn", ["The Every", "Player Piano"], [], ["Science Fiction"], ["反乌托邦", "dystopia", "technology"]),
    ("q025", "机器人 人工智能 科幻", "theme-cn", ["Robot"], [], ["Science Fiction"], ["robot", "AI", "人工智能"]),
    ("q026", "外星人入侵 经典科幻", "theme-cn", ["The War of the Worlds"], [], ["Science Fiction"], ["alien", "invasion", "火星"]),
    ("q027", "隐身 科学伦理 小说", "theme-cn", ["The Invisible Man"], [], ["Science Fiction", "Horror"], ["invisible", "ethics"]),
    ("q028", "末世 生存 家庭 科幻", "theme-cn", ["The Book of Sand"], [], ["Science Fiction"], ["末世", "生存", "post-apocalyptic"]),
    ("q029", "心理悬疑 恐怖小说", "theme-cn", ["The Chalk Man", "Pine"], [], ["Horror"], ["心理", "悬疑", "thriller"]),
    ("q030", "女巫 宗教 恐怖", "theme-cn", ["The Year of the Witching"], [], ["Horror"], ["witch", "religion", "feminist"]),
    ("q031", "self help personal growth beginner", "theme-en", ["The Power of Habit", "Inquiring about Myself", "The Magic Within"], [], ["Self-Help"], ["personal growth", "habit", "self"]),
    ("q032", "habit productivity psychology", "theme-en", ["The Power of Habit"], [], ["Self-Help"], ["habit", "productivity", "psychology"]),
    ("q033", "women empowerment self help groups", "theme-en", ["Empowerment of Women Through Self Help Groups"], [], ["Self-Help"], ["women", "empowerment"]),
    ("q034", "ego development psychology book", "theme-en", ["Measuring Ego Development", "The Development of the Ego", "Ego Analysis in the Helping Professions"], [], ["Self-Help"], ["ego", "psychology"]),
    ("q035", "Greek tragedy literary analysis", "theme-en", ["Hidden Paths"], [], ["Self-Help", "Classic"], ["Greek tragedy", "Euripides"]),
    ("q036", "sports biography inspirational", "theme-en", [], [], ["Sport"], ["sports", "biography", "inspirational"]),
    ("q037", "Japanese history social change", "theme-en", ["Japan Story"], [], ["History"], ["Japan", "history"]),
    ("q038", "economic behavior market anomalies", "theme-en", ["The Winner's Curse"], [], ["History", "Self-Help"], ["economics", "market", "behavior"]),
    ("q039", "mathematics history beginner", "theme-en", ["A History of Mathematics"], [], [], ["mathematics", "history"]),
    ("q040", "prime numbers Riemann hypothesis", "theme-en", ["The Music of the Primes"], [], [], ["prime", "Riemann", "mathematics"]),
    ("q041", "我想找一本适合入门的心理学和习惯养成的书", "natural-cn", ["The Power of Habit"], [], ["Self-Help"], ["习惯", "心理学", "入门"]),
    ("q042", "有没有关于科技公司控制社会的反乌托邦小说", "natural-cn", ["The Every"], [], ["Science Fiction"], ["科技", "垄断", "反乌托邦"]),
    ("q043", "想看简奥斯汀那种有婚恋和社会讽刺的作品", "natural-cn", ["Pride and Prejudice", "Sense and Sensibility"], ["Jane Austen"], ["Romantic"], ["婚恋", "讽刺"]),
    ("q044", "找一本外星文明入侵地球的经典科幻", "natural-cn", ["The War of the Worlds"], [], ["Science Fiction"], ["外星", "入侵"]),
    ("q045", "想读关于自动化取代人类工作的小说", "natural-cn", ["Player Piano"], [], ["Science Fiction"], ["自动化", "automation"]),
    ("q046", "有没有温情一点的爱情故事", "natural-cn", ["The Giver of Stars", "Mix Tape", "Live a Little"], [], ["Romantic"], ["温情", "爱情"]),
    ("q047", "找几本适合晚上读的恐怖悬疑小说", "natural-cn", ["The Chalk Man", "Pine", "The Year of the Witching"], [], ["Horror"], ["恐怖", "悬疑"]),
    ("q048", "我想看和星球大战有关的太空冒险", "natural-cn", ["A Star Wars Story"], [], ["Science Fiction"], ["Star Wars", "太空"]),
    ("q049", "有没有 Doctor Who 系列的科幻冒险", "natural-cn", ["Doctor Who: Molten Heart"], [], ["Science Fiction"], ["Doctor Who"]),
    ("q050", "想读女性成长和社会议题相关的书", "natural-cn", ["Empowerment of Women Through Self Help Groups", "The Year of the Witching"], [], ["Self-Help", "Horror"], ["女性", "成长"]),
    ("q051", "romantic classic by Jane Austen", "multi-condition", ["Pride and Prejudice", "Sense and Sensibility"], ["Jane Austen"], ["Romantic"], ["classic"]),
    ("q052", "Science Fiction H. G. Wells alien", "multi-condition", ["The War of the Worlds"], ["H. G. Wells"], ["Science Fiction"], ["alien"]),
    ("q053", "Science Fiction H. G. Wells invisible", "multi-condition", ["The Invisible Man"], ["H. G. Wells"], ["Science Fiction"], ["invisible"]),
    ("q054", "Horror feminist witch novel", "multi-condition", ["The Year of the Witching"], [], ["Horror"], ["feminist", "witch"]),
    ("q055", "Horror crime Scotland debut", "multi-condition", ["Pine"], [], ["Horror"], ["crime", "Scottish"]),
    ("q056", "Self-Help beginner introspection", "multi-condition", ["Inquiring about Myself"], [], ["Self-Help"], ["introspection", "beginner"]),
    ("q057", "Self-Help advanced ego measurement", "multi-condition", ["Measuring Ego Development", "The Development of the Ego"], [], ["Self-Help"], ["ego", "advanced"]),
    ("q058", "Science Fiction young adult dystopia", "multi-condition", ["Eve of Man"], [], ["Science Fiction"], ["young adult", "dystopia"]),
    ("q059", "Science Fiction psychological experiment", "multi-condition", ["Appliance"], [], ["Science Fiction"], ["experiment", "psychological"]),
    ("q060", "Romantic second chance music nostalgia", "multi-condition", ["Mix Tape"], [], ["Romantic"], ["second chance", "music"]),
    ("q061", "比较 Pride and Prejudice 和 Sense and Sensibility", "comparison", ["Pride and Prejudice", "Sense and Sensibility"], ["Jane Austen"], ["Romantic"], ["compare"]),
    ("q062", "compare The Every and Player Piano", "comparison", ["The Every", "Player Piano"], [], ["Science Fiction"], ["technology", "automation"]),
    ("q063", "compare H. G. Wells classic science fiction books", "comparison", ["The War of the Worlds", "The Invisible Man"], ["H. G. Wells"], ["Science Fiction"], ["classic"]),
    ("q064", "比较恐怖小说 The Chalk Man 和 Pine", "comparison", ["The Chalk Man", "Pine"], [], ["Horror"], ["compare", "horror"]),
    ("q065", "比较习惯养成和自我探索类书", "comparison", ["The Power of Habit", "Inquiring about Myself", "The Magic Within"], [], ["Self-Help"], ["habit", "self"]),
    ("q066", "科幻阅读路径 从经典到现代", "reading-path", ["The War of the Worlds", "The Invisible Man", "Player Piano", "The Every"], [], ["Science Fiction"], ["reading path"]),
    ("q067", "简奥斯汀阅读顺序", "reading-path", ["Pride and Prejudice", "Sense and Sensibility"], ["Jane Austen"], ["Romantic"], ["reading path"]),
    ("q068", "恐怖小说入门阅读路径", "reading-path", ["The Chalk Man", "Pine", "The Year of the Witching"], [], ["Horror"], ["reading path"]),
    ("q069", "自我管理和习惯养成阅读路径", "reading-path", ["The Power of Habit", "The Magic Within", "Inquiring about Myself"], [], ["Self-Help"], ["habit", "self management"]),
    ("q070", "数学入门阅读顺序", "reading-path", ["A History of Mathematics", "The Music of the Primes"], [], [], ["mathematics"]),
    ("q071", "AI 人工智能 入门", "metadata-fallback", ["Intelligence Science", "What Is Intelligence?"], [], [], ["artificial intelligence", "intelligence"]),
    ("q072", "machine learning intelligence science", "metadata-fallback", ["Intelligence Science", "What Is Intelligence?"], [], [], ["machine learning", "intelligence"]),
    ("q073", "Java 系统设计 编程", "metadata-fallback", [], [], [], ["Java", "system design", "programming"]),
    ("q074", "Portable C UNIX System Programming", "metadata-fallback", ["Portable C and UNIX System Programming"], [], [], ["C", "UNIX", "programming"]),
    ("q075", "Matrix Computations", "metadata-fallback", ["Matrix Computations"], [], [], ["matrix", "computations"]),
    ("q076", "The Art of Computer Programming algorithms", "metadata-fallback", ["The Art of Computer Programming: Semi-numerical algorithms"], [], [], ["algorithm", "programming"]),
    ("q077", "data intensive applications system design", "metadata-fallback", [], [], [], ["data", "system", "architecture"]),
    ("q078", "software architecture patterns", "metadata-fallback", [], [], [], ["software", "architecture"]),
    ("q079", "logic philosophy mathematical thinking", "metadata-fallback", ["Tractatus Logico-Philosophicus"], [], [], ["logic", "philosophy"]),
    ("q080", "decision making psychology economics", "metadata-fallback", ["The Winner's Curse"], [], [], ["decision", "economics", "psychology"]),
    ("q081", "找关于阅读和社区温情的小说", "natural-cn", ["The Giver of Stars"], [], ["Romantic"], ["阅读", "社区"]),
    ("q082", "寻找晚年爱情主题的当代小说", "natural-cn", ["Live a Little"], [], ["Romantic"], ["晚年", "爱情"]),
    ("q083", "找带有怀旧音乐元素的爱情小说", "natural-cn", ["Mix Tape"], [], ["Romantic"], ["音乐", "怀旧"]),
    ("q084", "寻找关于克隆技术伦理的科幻", "natural-cn", [], [], ["Science Fiction"], ["clone", "克隆", "ethics"]),
    ("q085", "寻找关于生物技术的科幻小说", "natural-cn", [], [], ["Science Fiction"], ["biotechnology", "biology"]),
    ("q086", "查找动作冒险类图书", "theme-cn", [], [], ["Action and Adventure"], ["adventure", "hero"]),
    ("q087", "查找儿童或青少年适合的故事", "theme-cn", [], [], ["Kids"], ["children", "young adult"]),
    ("q088", "历史类日本主题图书", "theme-cn", ["Japan Story"], [], ["History"], ["Japan", "history"]),
    ("q089", "足球运动员传记", "theme-cn", [], [], ["Sport"], ["football", "biography"]),
    ("q090", "拳击冠军 运动 女性", "theme-cn", [], [], ["Sport"], ["boxing", "women"]),
    ("q091", "经济学中的赢家诅咒", "exact-cn", ["The Winner's Curse"], [], [], ["winner's curse", "economics"]),
    ("q092", "素数的音乐", "exact-cn", ["The Music of the Primes"], [], [], ["prime", "music"]),
    ("q093", "数学史", "exact-cn", ["A History of Mathematics"], [], [], ["mathematics history"]),
    ("q094", "自助小组 女性赋权", "exact-cn", ["Empowerment of Women Through Self Help Groups"], [], ["Self-Help"], ["women empowerment"]),
    ("q095", "中年母亲 人生转变", "exact-cn", ["Midlife Mothers in Transition"], [], ["Self-Help"], ["midlife", "mother"]),
    ("q096", "非洲方向 自我成长", "exact-cn", ["In an African Direction"], [], ["Self-Help"], ["African", "self"]),
    ("q097", "内在魔法 心灵成长", "exact-cn", ["The Magic Within"], [], ["Self-Help"], ["magic within", "spiritual"]),
    ("q098", "矛盾的自我 心理学", "exact-cn", ["The Paradoxical Self"], [], ["Self-Help"], ["paradoxical self"]),
    ("q099", "家庭与自我 成长", "exact-cn", ["Self and Family"], [], ["Self-Help"], ["family", "self"]),
    ("q100", "母亲原型 女性灵性", "exact-cn", ["Motherself"], [], ["Self-Help"], ["mother", "spiritual"]),
]


RAG_QUESTIONS = [
    ("r001", "帮我推荐几本爱情小说，并说明推荐顺序。", "recommendation", ["Pride and Prejudice", "Sense and Sensibility", "The Giver of Stars", "Mix Tape"]),
    ("r002", "Pride and Prejudice 和 Sense and Sensibility 应该先读哪本？", "comparison", ["Pride and Prejudice", "Sense and Sensibility"]),
    ("r003", "我想从经典科幻入门，先读哪几本？", "reading-path", ["The War of the Worlds", "The Invisible Man", "Player Piano"]),
    ("r004", "The Every 和 Player Piano 都在讨论技术社会吗？帮我比较。", "comparison", ["The Every", "Player Piano"]),
    ("r005", "找几本关于外星人、未来社会或技术伦理的科幻。", "recommendation", ["The War of the Worlds", "The Every", "The Invisible Man"]),
    ("r006", "有没有关于机器人或人工智能主题的书？", "recommendation", ["Robot", "Intelligence Science", "What Is Intelligence?"]),
    ("r007", "帮我找几本恐怖悬疑小说，要求不要太学术。", "recommendation", ["The Chalk Man", "Pine", "The Year of the Witching"]),
    ("r008", "The Year of the Witching 适合什么读者？", "factual", ["The Year of the Witching"]),
    ("r009", "The Chalk Man 和 Pine 的风格有什么区别？", "comparison", ["The Chalk Man", "Pine"]),
    ("r010", "帮我做一个恐怖小说入门阅读路径。", "reading-path", ["The Chalk Man", "Pine", "The Year of the Witching"]),
    ("r011", "我想提升习惯和自我管理，应该读哪几本？", "reading-path", ["The Power of Habit", "The Magic Within", "Inquiring about Myself"]),
    ("r012", "The Power of Habit 为什么适合入门？", "factual", ["The Power of Habit"]),
    ("r013", "找几本关于自我探索和心理成长的书。", "recommendation", ["Inquiring about Myself", "The Magic Within", "The Paradoxical Self"]),
    ("r014", "ego development 相关书有哪些，难度如何？", "recommendation", ["Measuring Ego Development", "The Development of the Ego", "Ego Analysis in the Helping Professions"]),
    ("r015", "女性成长或女性赋权主题有哪些书？", "recommendation", ["Empowerment of Women Through Self Help Groups", "Midlife Mothers in Transition", "Motherself"]),
    ("r016", "Empowerment of Women Through Self Help Groups 主要适合谁读？", "factual", ["Empowerment of Women Through Self Help Groups"]),
    ("r017", "我想读日本历史或社会变迁方向的书。", "recommendation", ["Japan Story"]),
    ("r018", "The Winner's Curse 可以归到什么主题，为什么推荐？", "factual", ["The Winner's Curse"]),
    ("r019", "推荐几本数学入门相关的书，并说明先后顺序。", "reading-path", ["A History of Mathematics", "The Music of the Primes"]),
    ("r020", "The Music of the Primes 和 A History of Mathematics 哪本更适合先读？", "comparison", ["The Music of the Primes", "A History of Mathematics"]),
    ("r021", "帮我找几本和 Java 或系统设计相关的书。", "recommendation", ["Portable C and UNIX System Programming", "The Art of Computer Programming: Semi-numerical algorithms"]),
    ("r022", "如果没有 Java 书，系统应该如何基于证据回答？", "limitation", ["Portable C and UNIX System Programming"]),
    ("r023", "Portable C and UNIX System Programming 和算法书有什么区别？", "comparison", ["Portable C and UNIX System Programming", "The Art of Computer Programming: Semi-numerical algorithms"]),
    ("r024", "Tractatus Logico-Philosophicus 为什么会出现在数学或逻辑相关检索里？", "factual", ["Tractatus Logico-Philosophicus"]),
    ("r025", "推荐几本适合讨论逻辑、数学思维或算法的书。", "recommendation", ["A History of Mathematics", "The Music of the Primes", "The Art of Computer Programming: Semi-numerical algorithms", "Tractatus Logico-Philosophicus"]),
    ("r026", "我喜欢星球大战，有馆藏相关书吗？", "recommendation", ["A Star Wars Story"]),
    ("r027", "Doctor Who: Molten Heart 是什么类型的书？", "factual", ["Doctor Who: Molten Heart"]),
    ("r028", "Eve of Man 适合青少年读者吗？请基于证据回答。", "factual", ["Eve of Man"]),
    ("r029", "The Book of Sand 这本书适合什么样的科幻读者？", "factual", ["The Book of Sand"]),
    ("r030", "Appliance 和 The Book of Sand 都偏心理氛围吗？", "comparison", ["Appliance", "The Book of Sand"]),
    ("r031", "按入门、进阶、深入给我排几本科幻。", "reading-path", ["The War of the Worlds", "The Invisible Man", "Player Piano", "The Every"]),
    ("r032", "我想看科技伦理，但不要纯技术书，有哪些小说？", "recommendation", ["The Every", "Player Piano", "The Invisible Man"]),
    ("r033", "找几本带社会批判意味的小说。", "recommendation", ["The Every", "Player Piano", "Pride and Prejudice"]),
    ("r034", "Jane Austen 的作品有什么共同特点？", "author", ["Pride and Prejudice", "Sense and Sensibility"]),
    ("r035", "H. G. Wells 的两本馆藏作品怎么选？", "author", ["The War of the Worlds", "The Invisible Man"]),
    ("r036", "Jojo Moyes 的 The Giver of Stars 推荐理由是什么？", "factual", ["The Giver of Stars"]),
    ("r037", "Mix Tape 和 Live a Little 哪本更偏温情爱情？", "comparison", ["Mix Tape", "Live a Little"]),
    ("r038", "帮我找一本关于第二次机会的爱情小说。", "recommendation", ["Mix Tape"]),
    ("r039", "帮我找一本关于晚年爱情的小说。", "recommendation", ["Live a Little"]),
    ("r040", "找几本适合做女性主义或女性处境讨论的书。", "recommendation", ["The Year of the Witching", "Empowerment of Women Through Self Help Groups", "Motherself"]),
    ("r041", "我想读古典文学分析相关内容，馆藏有什么？", "recommendation", ["Hidden Paths"]),
    ("r042", "Hidden Paths 为什么可能不适合初学者？", "factual", ["Hidden Paths"]),
    ("r043", "找一本与家庭、自我和关系有关的自助书。", "recommendation", ["Self and Family"]),
    ("r044", "Midlife Mothers in Transition 面向什么人群？", "factual", ["Midlife Mothers in Transition"]),
    ("r045", "The Magic Within 和 Inquiring about Myself 哪本更适合入门？", "comparison", ["The Magic Within", "Inquiring about Myself"]),
    ("r046", "我想找关于母亲原型或女性灵性的书。", "recommendation", ["Motherself"]),
    ("r047", "帮我推荐一些历史类或真实事件相关书。", "recommendation", ["Japan Story"]),
    ("r048", "找运动或励志传记相关馆藏。", "recommendation", []),
    ("r049", "如果证据不足，回答应该怎样限制结论？", "limitation", []),
    ("r050", "基于当前馆藏，能不能推荐数据密集型系统设计书？", "limitation", []),
    ("r051", "请总结爱情类推荐证据里的共同主题。", "summary", ["Pride and Prejudice", "Sense and Sensibility", "The Giver of Stars", "Mix Tape"]),
    ("r052", "请总结科幻类推荐证据里的共同主题。", "summary", ["The War of the Worlds", "The Every", "Player Piano"]),
    ("r053", "请总结自我成长类书籍的常见适读人群。", "summary", ["The Power of Habit", "The Magic Within", "Inquiring about Myself"]),
    ("r054", "只看可借资源，爱情小说应该优先选哪本？", "recommendation", ["Pride and Prejudice", "Sense and Sensibility", "The Giver of Stars"]),
    ("r055", "只看可借资源，科幻小说应该优先选哪本？", "recommendation", ["The War of the Worlds", "The Invisible Man", "The Every"]),
    ("r056", "按难度重新排序这些自助书证据。", "reading-path", ["The Power of Habit", "The Magic Within", "The Paradoxical Self"]),
    ("r057", "继续找 Jane Austen 的相关作品。", "author", ["Pride and Prejudice", "Sense and Sensibility"]),
    ("r058", "继续找 H. G. Wells 的相关作品。", "author", ["The War of the Worlds", "The Invisible Man"]),
    ("r059", "帮我比较几本数学和逻辑相关的书。", "comparison", ["A History of Mathematics", "The Music of the Primes", "Tractatus Logico-Philosophicus"]),
    ("r060", "请给一个从爱情小说到社会讽刺的阅读路径。", "reading-path", ["Pride and Prejudice", "Sense and Sensibility", "The Every"]),
]


def search_record(item: tuple[str, str, str, list[str], list[str], list[str], list[str], list[str]]) -> dict:
    if len(item) == 7:
        query_id, query, intent, title_hints, author_hints, category_hints, keyword_hints = item
        tag_hints = []
    else:
        query_id, query, intent, title_hints, author_hints, category_hints, keyword_hints, tag_hints = item
    return {
        "id": query_id,
        "query": query,
        "intent": intent,
        "description": f"{intent} evaluation query for ReadSeek hybrid retrieval.",
        "relevantResourceIds": [],
        "relevance": {
            "titleHints": title_hints,
            "authorHints": author_hints,
            "categoryHints": category_hints,
            "tagHints": tag_hints,
            "keywordHints": keyword_hints,
            "maxRelevantIds": 12,
        },
    }


def rag_record(item: tuple[str, str, str, list[str]]) -> dict:
    question_id, question, answer_mode, title_hints = item
    return {
        "id": question_id,
        "question": question,
        "answerMode": answer_mode,
        "expectedResourceIds": [],
        "relevance": {
            "titleHints": title_hints,
            "maxRelevantIds": 8,
        },
        "manualRubric": {
            "relevance": "0-5: answer addresses the question using retrieved catalog evidence.",
            "completeness": "0-5: answer covers requested comparison/order/recommendation dimensions.",
            "citationValidity": "0-5: citations point to actually relevant evidence cards.",
            "hallucinationRisk": "0-5: 5 means no unsupported catalog-external claims.",
        },
    }


def main() -> int:
    search_queries = [search_record(item) for item in SEARCH_QUERIES]
    rag_questions = [rag_record(item) for item in RAG_QUESTIONS]
    if len(search_queries) != 100:
        raise RuntimeError(f"Expected 100 search queries, got {len(search_queries)}")
    if len(rag_questions) != 60:
        raise RuntimeError(f"Expected 60 RAG questions, got {len(rag_questions)}")

    write_json("docs/evaluation/search_queries_100.json", {
        "dataset": "readseek-search-100",
        "status": "ready-for-resolution",
        "note": "Relevant ids can be resolved dynamically from current catalog by scripts/run_retrieval_evaluation.py.",
        "queries": search_queries,
    })
    write_json("docs/evaluation/rag_questions_60.json", {
        "dataset": "readseek-rag-60",
        "status": "ready-for-batch-evaluation",
        "note": "Expected ids can be resolved dynamically from current catalog; manual scores should be filled after reviewing generated answers.",
        "questions": rag_questions,
    })
    print("Generated docs/evaluation/search_queries_100.json")
    print("Generated docs/evaluation/rag_questions_60.json")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
