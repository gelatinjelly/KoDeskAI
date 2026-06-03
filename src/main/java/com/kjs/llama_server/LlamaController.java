package com.kjs.llama_server;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
public class LlamaController {
    private final ChatClient chatClient;
    private final WebClient webClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public LlamaController(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
        this.webClient = WebClient.builder()
                .baseUrl("http://localhost:8000")
                .build();
    }

    @GetMapping(value = "/ask-stream", produces = "text/event-stream;charset=UTF-8")
    public Flux<String> askStream(
            @RequestParam String message,
            @RequestParam(value = "history", required = false, defaultValue = "[]") String historyJson
    ) {
        // 히스토리 파싱
        List<Map<String, String>> history = Collections.emptyList();
        try {
            history = objectMapper.readValue(historyJson,
                    objectMapper.getTypeFactory().constructCollectionType(List.class, Map.class));
        } catch (Exception ignored) {}

        // 대화 이력 → 프롬프트 구성
        StringBuilder prompt = new StringBuilder();
        prompt.append("### 지시: 당신은 데스크탑 AI 비서입니다. ")
                .append("이전 대화 내용을 참고하여 사용자의 질문에 친절하고 정확하게 답변해줘.\n\n");

        // 이전 대화 삽입
        if (!history.isEmpty()) {
            prompt.append("### 이전 대화:\n");
            for (Map<String, String> turn : history) {
                String role    = turn.getOrDefault("role", "user");
                String content = turn.getOrDefault("content", "");
                if ("user".equals(role)) {
                    prompt.append("사용자: ").append(content).append("\n");
                } else {
                    prompt.append("AI: ").append(content).append("\n");
                }
            }
            prompt.append("\n");
        }

        prompt.append("### 입력: ").append(message).append("\n")
                .append("### 답변:");

        return chatClient.prompt()
                .user(prompt.toString())
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