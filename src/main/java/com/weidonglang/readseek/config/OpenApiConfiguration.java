package com.weidonglang.readseek.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfiguration {

    @Bean
    public OpenAPI readSeekOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("ReadSeek Reading Resource Discovery API")
                        .description("Natural-language hybrid retrieval, evidence-grounded QA, and explainable recommendation APIs for reading resource discovery.")
                        .version("v0.1.0-beta"));
    }
}
