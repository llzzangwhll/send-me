# SendMe

> **Vibe Coding with Claude Code** - 이 프로젝트는 [Claude Code](https://claude.ai/code)를 활용한 바이브코딩(Vibe Coding)으로 개발되었습니다.

계좌 정보를 QR 코드로 쉽게 공유할 수 있는 Flutter 앱입니다.

## 주요 기능

- **계좌 카드 관리** - 여러 은행 계좌를 등록하고 관리
- **QR 코드 생성** - 계좌 정보를 담은 QR 코드 자동 생성 (범용 QR 리더 호환)
- **QR 코드 스캔** - 다른 사람의 SendMe QR 코드를 스캔하여 계좌 정보 확인
- **간편 공유** - QR 이미지 또는 텍스트로 카카오톡 등 메신저에 공유
- **링크 공유** - toss.me / 카카오페이 송금 링크를 바로 공유
- **클립보드 복사** - 계좌번호, 은행명 등 개별 필드 원터치 복사
- **스플래시 화면** - 커스텀 앱 아이콘 및 스플래시 화면 적용

## 기술 스택

- **Flutter** (Dart)
- **GetX** - 상태 관리, 라우팅, 의존성 주입
- **MVVM 패턴** - ViewModel과 View 분리
- **Hive** - 로컬 NoSQL 저장소
- **qr_flutter** - QR 코드 렌더링
- **mobile_scanner** - 카메라 QR 스캔
- **share_plus** - 네이티브 공유 기능
- **url_launcher** - 외부 링크 처리
- **Material 3** - 모던 UI 디자인

## 프로젝트 구조

```
lib/
  main.dart                          # 앱 진입점
  app.dart                           # GetMaterialApp 설정
  core/
    constants.dart                   # 은행 목록, 카드 색상
    theme.dart                       # Material 3 테마
    utils/
      qr_codec.dart                  # QR 인코딩/디코딩
      formatters.dart                # 금액 포맷, 계좌 마스킹
  models/
    payment_card.dart                # 결제 카드 모델 (Hive)
  data/
    hive_boxes.dart                  # Hive 초기화
  services/
    payment_card_service.dart        # CRUD 서비스
  viewmodels/
    home_viewmodel.dart              # 홈 화면 VM
    card_editor_viewmodel.dart       # 카드 추가/수정 VM
    card_detail_viewmodel.dart       # 상세/공유/QR VM
    scan_viewmodel.dart              # QR 스캔 VM
  views/
    home/                            # 메인 카드 목록
    card_editor/                     # 카드 추가/수정
    card_detail/                     # QR + 상세 정보
    scan/                            # QR 스캔 + 결과
```

## QR 코드 형식

아무 QR 리더에서도 읽을 수 있는 한국어 평문 텍스트를 사용합니다:

```
Send Me
은행: 카카오뱅크
계좌: 3333-12-3456789
예금주: 홍길동
금액: 50,000원
메모: 4월 모임 회비

https://toss.me/honggildong
```

## 시작하기

```bash
# 의존성 설치
flutter pub get

# Hive 어댑터 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 실행
flutter run

# APK 빌드
flutter build apk --release
```

## 요구 사항

- Flutter 3.32+
- Dart 3.8+
- Android SDK 36 / minSdk 23
- iOS 12.0+
