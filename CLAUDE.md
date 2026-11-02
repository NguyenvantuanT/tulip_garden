# CLAUDE.md

Mục lục cho agent. Giữ file này ngắn (hook báo khi > 150 dòng) — chi tiết nằm ở `docs/`, ở đây chỉ trỏ tới.

Game 2D Flutter + Flame, dùng plugin `vtinter-harness`. Convention chung nằm trong skill `flutter-*` của plugin; fact riêng của dự án nằm trong repo này. Lệch nhau → repo này + code thật thắng. Skill viết cho app MVVM + Provider: phần game (`lib/game/`) theo pattern component của Flame, không ép vào BaseViewModel/MixinBasePage.

## Làm việc

- Sửa nhỏ (1–2 file, yêu cầu rõ) → làm trực tiếp, load đúng 1 skill cần thiết. Feature nhiều file / cần khảo sát rộng → giao subagent `flutter-mobile-dev` (subagent khởi động lạnh, chỉ đáng khi việc đủ lớn). Hook áp dụng cho cả hai cách.
- Task lớn (> 1 PR hoặc nhiều quyết định) → viết exec plan ở `docs/exec-plans/active/` trước khi code (format: `docs/PLANS.md`).
- Xong việc → hook tự chạy `check.sh` + `docs-check.sh` + `flutter analyze`. Fail thì sửa, không bỏ qua.
- Agent làm sai vì thiếu context → bổ sung vào `docs/`; sai lặp lại → đề xuất rule mới cho `check.sh`.

## Project

- **Package**: `tulip_garden` — game idle trồng và lai giống tulip
- **Apps**: 1 app · **Platform**: iOS, Android, web
- **Engine**: Flame (`lib/game/`)
- **Backend**: chưa có (lưu local) · **Model**: manual (khớp `HARNESS_MODEL_STYLE`)
- **Locale**: chưa có i18n
- **Flutter**: `3.41.0` qua FVM

## Chạy

```bash
fvm flutter run -d chrome
fvm flutter test
```

Agent tự kiểm chứng trên app thật: skill `flutter-run-and-verify`.

## Bản đồ tri thức

| Cần biết | Đọc |
|---|---|
| Domain, layer, package map | `ARCHITECTURE.md` |
| Nguyên tắc bất biến (golden principles) | `docs/golden-principles.md` |
| Chất lượng từng domain/layer, gap đang theo dõi | `docs/QUALITY_SCORE.md` |
| Nợ kỹ thuật đã biết, xung đột rule ↔ code | `docs/tech-debt-tracker.md` |
| Task trên Kanzo, Definition of Done | `docs/task-workflow.md` |
| Việc đang làm / đã xong | `docs/exec-plans/active/`, `docs/exec-plans/completed/` |
| Spec sản phẩm | `docs/product-specs/` |

## Ngoại lệ đã chấp nhận

Mỗi ngoại lệ = 1 dòng + rule id tương ứng trong `.claude/harness.env` (`HARNESS_DISABLE`) nếu tắt cả rule.

- Chưa có.
