# ARCHITECTURE

Bản đồ cấp cao. Mọi đường dẫn trong backtick được `docs-check.sh` kiểm tra tồn tại — đổi tên file thì sửa ở đây.

## Layer (hướng phụ thuộc chỉ đi xuống)

```
main.dart                Flutter shell: MaterialApp + GameWidget
game/                    FlameGame + component (ruộng, hoa, UI trong game)
src/resources/           AppColor — token màu, dùng cho cả game lẫn widget
src/ (khi cần)           pages/ components/ services/ models/ theo bộ base — menu, cửa hàng, lưu game
```

Hướng import trong `src/` được `check.sh` ép (rule `layer_*`). `lib/game/` chưa có rule máy.

## Domain

| Domain | Game | Models | Services |
|---|---|---|---|
| Garden (ruộng, trồng, thu hoạch) | `lib/game/` | chưa có | chưa có |

## Entry points & DI

- Entry: `lib/main.dart`
- Game: `lib/game/tulip_garden_game.dart`
- Màu: `lib/src/resources/app_color.dart`
- Thời gian: `lib/game/clock.dart` — chỗ duy nhất gọi `DateTime.now()`; logic nhận `Clock` truyền vào, thời lượng các giai đoạn của hoa ở `lib/game/growth.dart`
- DI / Router: chưa có
