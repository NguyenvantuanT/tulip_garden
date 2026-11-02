# Task workflow (Kanzo)

Task nằm trên board Kanzo, project `tulip` (repo `NguyenvantuanT/tulip_garden`). Mỗi task ghi skill cần load + acceptance criteria riêng; phần dưới áp dụng cho mọi task.

## Vòng đời

1. `next_task` → task sang `doing`. Comment plan: file sẽ chạm, skill sẽ load, acceptance criteria.
2. Làm theo quy trình của agent `flutter-mobile-dev` (hiểu → plan → code → harness → kiểm chứng → ghi lại).
3. Comment tiến độ ở mốc chính; bị chặn (cần dependency, spec mơ hồ, muốn tắt rule) → comment câu hỏi, chuyển `review`, dừng.
4. Xong → comment report (bên dưới), chuyển `review`. Chỉ user chuyển `done`. Task Human để user làm.

## Definition of Done

- [ ] Acceptance criteria của task đều kiểm chứng được và đã kiểm chứng.
- [ ] Logic game là class Dart thuần trong `lib/game/`, có unit test mirror đường dẫn trong test/ (golden principle #5, skill `flutter-testing`); test mới đã thấy fail trước.
- [ ] `fvm flutter test` pass.
- [ ] `check.sh` sạch trên dòng mới (hook post-edit / stop). Vi phạm cũ ngoài task không sửa — ghi `docs/tech-debt-tracker.md`.
- [ ] `docs-check.sh` + `fvm flutter analyze` sạch (hook stop).
- [ ] Đổi UI/flow → skill `flutter-run-and-verify`: chạy app thật, ảnh trước/sau đính trong comment.
- [ ] Tự review diff theo skill `ai-code-review` trước khi chuyển `review`.
- [ ] Doc lệch code → sửa doc trong cùng commit (`ARCHITECTURE.md`, `docs/QUALITY_SCORE.md`).
- [ ] 1 task = 1 branch `task/tulip-<n>-<slug>` + 1 PR, message commit có `tulip#<n>`.

## Dừng hỏi user

Thêm dependency (pin exact version), đổi cấu trúc folder / golden principles, tắt rule harness, spec mơ hồ — theo agent `flutter-mobile-dev`.

## Report (comment cuối)

File đã đổi · quyết định · kết quả test/analyze/check · ảnh trước/sau · PR link · việc còn mở.
