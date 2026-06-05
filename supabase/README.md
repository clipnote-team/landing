# Supabase 운영 가이드

`landing/`은 아래 Supabase 프로젝트를 기준으로 운영합니다.

- project ref: `shagpfxjqvbrytntjikg`
- project name: `clipnote-landing`
- region: `ap-northeast-2 (Seoul)`
- landing page source of truth: [index.html](../index.html)
- waitlist schema source of truth: [waitlist.sql](./waitlist.sql)

## MCP 연결

이 저장소에는 프로젝트 범위로 고정된 `.mcp.json`이 들어 있습니다.

- MCP 서버: `https://mcp.supabase.com/mcp`
- scope: `project_ref=shagpfxjqvbrytntjikg`
- features: `database,debugging,development,docs`

Supabase 공식 문서 기준으로, MCP 서버를 추가한 뒤 한 번 인증이 필요합니다.

1. `landing/`을 기준 디렉터리로 연다.
2. MCP 인증 플로우를 시작한다.
3. 브라우저에서 Supabase 로그인 후, 이 프로젝트가 속한 조직 접근 권한을 허용한다.
4. 세션을 새로고침하거나 에이전트를 다시 시작한다.

인증이 끝나면 `list_tables`, `execute_sql`, `get_logs` 같은 MCP 도구를 바로 사용할 수 있습니다.

## waitlist 계약

랜딩 페이지의 이메일 신청 폼은 `public.waitlist`에 아래 필드로 insert 합니다.

- `email`
- `source`

DB가 자동으로 채우는 필드는 아래와 같습니다.

- `id`
- `created_at`

현재 프런트 코드는 아래 호출을 사용합니다.

- `sb.from("waitlist").insert({ email, source })`

즉, 테이블 이름이나 컬럼명이 바뀌면 랜딩 페이지도 같이 수정해야 합니다.

## 권장 보안 상태

의도한 보안 모델은 아래와 같습니다.

- `anon`은 `INSERT`만 허용
- `SELECT / UPDATE / DELETE`는 공개 차단
- RLS 활성화

만약 퍼블릭 키로 `SELECT`가 되는 상태라면, `waitlist.sql`의 권한/RLS 기준으로 다시 맞추는 것을 권장합니다.

## 방문 분석

랜딩 페이지는 Microsoft Clarity로 방문 행동을 확인합니다.

- project id: `x1nf07g78k`
- production URL: `https://clipnote-landing.vercel.app/`
- 추적 이벤트: `waitlist_submit_attempt`, `waitlist_submit_success`, `waitlist_submit_duplicate`, `waitlist_submit_error`
- 이메일 입력칸은 `data-clarity-mask="True"`로 마스킹합니다.
