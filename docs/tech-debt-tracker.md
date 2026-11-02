# Tech debt tracker

Nợ kỹ thuật + xung đột rule ↔ code đã biết. Agent đọc file này thay vì đoán; `harness-gardening` cập nhật định kỳ. Xong thì xoá dòng (git giữ lịch sử).

| ID | Ở đâu | Vấn đề | Hướng xử lý | Trạng thái |
|---|---|---|---|---|
| TD-3 | `lib/game/` | Skill `flutter-*` viết cho MVVM + Provider, chưa có convention cho code Flame | Bổ sung rule game vào `docs/golden-principles.md` khi pattern ổn định | open |
