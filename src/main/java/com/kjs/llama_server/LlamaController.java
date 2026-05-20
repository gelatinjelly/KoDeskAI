package com.kjs.llama_server;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
public class LlamaController {
    private final ChatClient chatClient;
    private final WebClient webClient;

    public LlamaController(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
        this.webClient = WebClient.builder()
                .baseUrl("http://localhost:8000")
                .build();
    }

    @GetMapping(value = "/ask-stream", produces = "text/event-stream;charset=UTF-8")
    public Flux<String> askStream(@RequestParam String message) {
        String formattedPrompt = String.format(
                "### 지시: 당신은 데스크탑 AI 비서입니다. 사용자의 질문이나 요청에 대해 친절하고 정확하게 답변해줘.\n" +
                        "### 입력: %s\n" +
                        "### 답변:",
                message
        );
        return chatClient.prompt()
                .user(formattedPrompt)
                .stream()
                .content();
    }

    @PostMapping(value = "/analyze-file", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Mono<String> analyzeFile(@RequestParam("file") MultipartFile file) throws Exception {
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("file", new ByteArrayResource(file.getBytes()) {
            @Override public String getFilename() { return file.getOriginalFilename(); }
        }).contentType(MediaType.APPLICATION_OCTET_STREAM);

        return webClient.post()
                .uri("/analyze")
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .bodyValue(builder.build())
                .retrieve()
                .bodyToMono(String.class);
    }

    @PostMapping(value = "/ask-with-file", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Mono<String> askWithFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "question", defaultValue = "이 문서의 핵심 내용을 요약해줘") String question
    ) throws Exception {
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("file", new ByteArrayResource(file.getBytes()) {
            @Override public String getFilename() { return file.getOriginalFilename(); }
        }).contentType(MediaType.APPLICATION_OCTET_STREAM);
        builder.part("question", question);

        return webClient.post()
                .uri("/ask-with-file")
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .bodyValue(builder.build())
                .retrieve()
                .bodyToMono(String.class);
    }
}