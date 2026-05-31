package com.weidonglang.readseek.llm;

public interface LlmChatClient {
    boolean supports(String provider);

    LlmChatResult chat(LlmChatRequest request);
}
