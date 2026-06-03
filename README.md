<<<<<<< HEAD
# KoDeskAI 🤖

> 완전 오프라인으로 동작하는 한국어 특화 데스크탑 AI 비서

## 소개

KoDeskAI는 인터넷 연결 없이 로컬에서 완전히 동작하는 AI 비서입니다.
Llama 3.1 8B 모델을 한국어 데이터로 파인튜닝하여 한국어 응답에 최적화되어 있습니다.

## 주요 기능

- 💬 **실시간 스트리밍 채팅** - 답변이 실시간으로 스트리밍됩니다
- 📎 **파일 분석** - PDF, Word, Excel, TXT 파일 요약 및 질의응답
- 🔒 **완전 오프라인 동작** - 개인정보가 외부로 전송되지 않습니다
- ⚡ **GPU 가속 지원** - NVIDIA RTX GPU로 빠른 응답 속도

## 시스템 요구사항

| 항목 | 최소 | 권장 |
|------|------|------|
| OS | Windows 10 64bit | Windows 11 64bit |
| GPU | NVIDIA GTX 1060 6GB | NVIDIA RTX 3060 이상 |
| RAM | 16GB | 32GB |
| 저장공간 | 10GB | 20GB |

> ⚠️ GPU 없이도 동작하지만 응답 속도가 매우 느릴 수 있습니다.

## 설치 방법

### 1. 다운로드

이 저장소를 ZIP으로 다운로드하거나 git clone하세요.

```bash
git clone https://github.com/gelatinjelly/KoDeskAI.git
cd KoDeskAI
```

### 2. 설치 실행

`install.bat`을 **관리자 권한으로 실행**하세요.

```
install.bat 더블클릭 → 우클릭 → 관리자 권한으로 실행
```

설치 스크립트가 자동으로 다음을 수행합니다:
- Ollama 설치
- Java 17 설치
- Python 설치 및 라이브러리 설치
- AI 모델 다운로드 (약 4.5GB, 시간이 걸립니다)
- Ollama에 모델 등록

### 3. 실행

설치 완료 후 `start.bat`을 실행하세요.

```
start.bat 더블클릭
```

### 4. 접속

브라우저에서 아래 주소로 접속하세요.

```
http://localhost:8080
```

## 사용 방법

### 채팅
- 하단 입력창에 질문을 입력하고 Enter 또는 전송 버튼 클릭
- AI가 실시간으로 답변을 스트리밍합니다

### 파일 분석
- 상단 **📎 파일 분석** 탭 클릭
- PDF, Word, Excel, TXT 파일 업로드
- 질문 입력 후 **분석** 버튼 클릭

## 종료 방법

`stop.bat`을 실행하거나 CMD 창을 닫으세요.

## 기술 스택

| 구성요소 | 기술 |
|---------|------|
| AI 모델 | Llama 3.1 8B (QLoRA 파인튜닝) |
| 양자화 | q4_k_m (4.5GB) |
| 추론 엔진 | Ollama |
| 백엔드 | Spring Boot 4.0 |
| 파일 분석 | Python FastAPI |
| 프론트엔드 | HTML/CSS/JavaScript |

## 학습 데이터

| 데이터셋 | 건수 | 설명 |
|---------|------|------|
| custom_data | 1,500건 | 직접 제작 고품질 데이터 |
| CodeFeedback | 3,000건 | 코드 관련 Q&A (한자 필터링) |
| ko_wikidata_QA | 2,000건 | 한국어 위키 Q&A |
| **합계** | **5,359건** | |

## 라이선스

이 프로젝트는 [Llama 3.1 Community License](https://github.com/meta-llama/llama-models/blob/main/models/llama3_1/LICENSE) 를 따릅니다.

## 문의

- GitHub Issues: [KoDeskAI Issues](https://github.com/gelatinjelly/KoDeskAI/issues)
=======
# KoDeskAI
오프라인으로 동작하는 한국어 특화 로컬 AI 비서
>>>>>>> ce3eb8e30b2e968aba6437b5302111aec706c288
