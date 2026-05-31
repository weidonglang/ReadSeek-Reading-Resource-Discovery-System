package com.weidonglang.readseek.llm;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LlmChatRequest {
    private String provider;
    private String model;
    private String mode;
    private String systemPrompt;
    private String userPrompt;
    private double temperature;
    private double topP;
    private int numCtx;
    private int numPredict;
    private String keepAlive;
    private int timeoutSeconds;
}
