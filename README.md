# Aha Owlet 핀 호스팅 (aha-owlet-pins)

> 2026-08-12 신설. 목적: **회사의 시각 자산을 공개 URL로 만드는 유일한 경로.**

## 왜 만들었나

2026-08-12에 Pinterest 실험을 실행하려다 **이미지를 플랫폼에 넣는 경로가 전부 막혀 있다**는 것을 확인했다.

| 시도 | 결과 |
|---|---|
| 브라우저 file_upload 도구 | 세션에서 미지원 |
| computer-use로 윈도우 파일 선택 창 조작 | **하드 차단** — 파일 대화상자의 소유 프로세스가 Chrome이고, 브라우저는 카테고리상 항상 "읽기" 등급이라 클릭·입력 불가. 승인으로 풀리지 않음 |
| Notion을 임시 호스트로 사용 | 업로드·게시까지 성공했으나 **Pinterest가 notion.site 이미지 프록시 요청을 거부** |

즉 **비서팀장은 로컬 파일을 웹에 올릴 수 없다.** 그런데 GitHub Pages에 한 번 올려두면 그 뒤는 공개 URL이므로, Pinterest·Gumroad·Beacons·KDP A+ 등 **어디서든 URL로 가져다 쓸 수 있다.**

이 폴더가 그 관문이다.

## 최초 1회 설정 (사장)

1. github.com 에서 **빈 저장소 생성**: 이름 `aha-owlet-pins`, **Public**, README 생성 **체크 해제**
2. 이 폴더의 **`push.bat` 더블클릭**
3. 끝. (Pages 활성화는 비서팀장이 브라우저로 처리)

> 자격증명은 사장 PC의 git에 이미 저장돼 있다(blastrix·lumina·math-board 푸시 이력). 비서팀장은 토큰·비밀번호를 다루지 않는다 — 회사 규칙이자 Claude 운영원칙.

## 이후 운영 (반복)

1. 비서팀장이 새 이미지를 이 폴더에 넣는다 (자동)
2. 사장이 `push.bat` 더블클릭 (10초)
3. 비서팀장이 공개 URL로 Pinterest·기타 채널에 게시 (자동)

**사장 개입은 2번 한 단계뿐이다.** 그 전까지는 핀 1장마다 파일 선택 창을 15번 다뤄야 했다.

## 공개 URL 규칙

```
https://seun3won.github.io/aha-owlet-pins/<파일명>
```

예: `https://seun3won.github.io/aha-owlet-pins/01-tantrum-cheat-sheet.png`

## 현재 담긴 것 (2026-08-12)

Pinterest 실험 #1용 핀 15장(1000×1500). 제목·설명·링크·보드는 `../pinterest-pins/_게시메타데이터.md` 참고.

- 01~02 무료 리드마그넷 (전환)
- 03~12 육아과학 팁 (검색 유입)
- 13~15 유료 노션 템플릿 (퍼널 하단)

## 2026-08-14 확장 — 이미지 창고 → 회사 웹 배포 게이트웨이

이 저장소는 이제 이미지뿐 아니라 **무료 웹툴 라인**도 서비스한다.

```
/tools/                    툴 목록 페이지
/tools/wake-windows/       1호 Wake Window Calculator
/p/<slug>/                 Pinterest 핀별 랜딩 페이지 15개
/robots.txt                전체 허용 (아래 주의 참고)
/sitemap.xml               전 페이지 URL 목록
```

**`/p/` 가 왜 있나**: Pinterest는 Save-from-URL 핀의 제목·설명을 **목적지 페이지의 og 메타에서 가져오고, 게시 후에는 편집을 막는다**(2026-08-14 실측). 그래서 핀마다 우리가 통제하는 페이지를 두고 그 메타가 곧 핀 메타가 되게 한다. 생성기는 `../tools/make_pin_pages.py`.

**신규 툴 배포 절차**: `tools/<이름>/index.html` 작성 → `sitemap.xml`에 URL 추가 → `tools/index.html` 카드 교체 → `push.bat` → 라이브 확인 → **Search Console에서 색인 생성 요청 1회**.

## 주의

- ⛔ **robots.txt에 이미지 차단 규칙을 넣지 않는다.** 08-14에 `Disallow: /*.png$`를 넣었다가 **Pinterest 스크레이퍼가 이미지를 못 가져와** 핀 생성이 전부 실패했다(`upstream r…`). 원복 후 정상 동작 확인.
- ⛔ **`google2f27ab670c9d7c73.html`을 절대 삭제하지 않는다.** Google Search Console 소유권 확인 파일이며, 지우면 소유권이 해제돼 검색 실적 데이터가 끊긴다.
- 툴 페이지에서 Beacons 링크는 **JS로 만들지 말고 href에 직접 박는다.** JS로 넣으면 크롤러에 빈 링크로 보이고, JS가 실패하면 퍼널이 끊긴다(08-14 실제 발생, 수정 완료).
- 이 저장소는 **Public**이다. 미공개 자산·개인정보·자격증명을 절대 넣지 않는다.
- 생성기는 `../tools/make_pins.py`. 핀을 고치려면 원본 스크립트를 고치고 다시 생성한 뒤 이 폴더에 복사한다.
