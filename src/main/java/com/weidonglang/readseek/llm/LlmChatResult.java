package com.weidonglang.readseek.llm;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LlmChatResult {
    private String content;
    private String provider;
    private String model;
    private String backend;
    private long latencyMs;
}
