# Tech debt tracker

Nợ kỹ thuật + xung đột rule ↔ code đã biết. Agent đọc file này thay vì đoán; `harness-gardening` cập nhật định kỳ. Xong thì xoá dòng (git giữ lịch sử).

| ID | Ở đâu | Vấn đề | Hướng xử lý | Trạng thái |
|---|---|---|---|---|
| TD-1 | `lib/game/tulip_garden_game.dart` | `color_literal`: 2 vi phạm, dùng `Color(0x...)` trực tiếp | Tạo bảng màu game (vd `AppColor` trong src/resources/) hoặc tắt rule nếu game dùng palette riêng — chờ quyết định | open |
| TD-2 | `pubspec.yaml` | `caret_version`: 4 vi phạm (`sdk`, `cupertino_icons`, `flame`, `flutter_lints`) | Pin exact version theo `pubspec.lock`; `sdk:` trong `environment` là false positive | open |
| TD-3 | `lib/game/` | Skill `flutter-*` viết cho MVVM + Provider, chưa có convention cho code Flame | Bổ sung rule game vào `docs/golden-principles.md` khi pattern ổn định | open |
