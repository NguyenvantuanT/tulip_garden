# Tulip Garden

Game 2D idle nhỏ: trồng tulip trên ruộng dạng lưới, chờ hoa lớn, thu hoạch để kiếm xu. Viết bằng Flutter + [Flame](https://flame-engine.org/), chạy trên iOS, Android và web.

> **Trạng thái: đã đóng.** Dự án dừng sau khi xong vòng chơi cơ bản (trồng → lớn → thu hoạch → kiếm xu). Các phần dở dang được liệt kê bên dưới.

## Chơi thế nào

- Ruộng 4×4 ô đất.
- **Chạm ô trống** để trồng một củ tulip.
- Hoa lớn theo thời gian thật qua 4 giai đoạn: củ → mầm → nụ → nở (tổng 2 phút).
- **Chạm hoa đã nở** để thu hoạch, được **+10 xu**, ô trở lại trống. Chạm khi hoa chưa nở thì không có gì xảy ra.
- Số xu hiển thị ở góc trái trên.

## Chạy

Cần [FVM](https://fvm.app/). Phiên bản Flutter được ghim trong `.fvmrc`.

```bash
fvm install
fvm flutter pub get
fvm flutter run -d chrome     # hoặc thiết bị iOS/Android
fvm flutter test
```

## Đã làm

| Task | Nội dung |
|---|---|
| tulip#9 | Baseline harness: token màu `AppColor`, ghim version dependency |
| tulip#1 | Ruộng dạng lưới, tự co giãn và căn giữa theo màn hình |
| tulip#3 | Hoa lớn theo thời gian (UTC, clock truyền vào, không đếm frame) |
| tulip#2 | Chạm để trồng / thu hoạch, trả kết quả rõ thay vì throw |
| tulip#4 | Xu game kiểu `int`, có trần chống tràn; HUD hiển thị số xu |

Có 38 test: unit test cho logic (lưới, giai đoạn lớn, trồng/thu hoạch, tiền) và widget test chạm thật qua `GameWidget`.

## Chưa làm

- **tulip#6 Cửa hàng** (mở rộng ruộng, phân bón): mới có logic, chưa có UI và test. Code nằm ở branch task/tulip-6-shop, chưa merge.
- **tulip#5 Lai giống** ra màu mới: chưa bắt đầu.
- **tulip#7 Lưu và tải game**: chưa bắt đầu (cần thêm `shared_preferences`).

## Cấu trúc

```
lib/
  main.dart                 MaterialApp + GameWidget
  game/                     logic (Dart thuần) + component Flame
    garden_state.dart       ruộng, trồng, thu hoạch, số xu
    growth.dart             giai đoạn lớn của hoa
    economy.dart            giá và cộng xu
    clock.dart              nơi duy nhất gọi DateTime.now()
    components/             phần vẽ: ô đất, hoa, HUD
  src/resources/            AppColor
test/game/                  unit + widget test
```

Logic game là Dart thuần, tách khỏi phần vẽ, nên test được không cần engine. Chi tiết xem `ARCHITECTURE.md` và `docs/golden-principles.md`.

## Cách dự án được làm

Toàn bộ code được viết bởi Claude Code, theo bộ harness `vtinter-harness`:

- Mỗi task trên board [Kanzo](https://github.com/emanuele-em/kanzo) đi qua 1 branch và 1 PR vào `develop`.
- Definition of Done (`docs/task-workflow.md`):
  - Test phải fail trước khi sửa code.
  - `check.sh`, `docs-check.sh` và `flutter analyze` đều sạch.
  - Chạy thật trên web và chụp ảnh trước/sau.
- Hướng dẫn cho agent: `CLAUDE.md`.
