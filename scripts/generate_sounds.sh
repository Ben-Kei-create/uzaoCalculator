#!/bin/bash
# generate_sounds.sh
# 効果音を生成するスクリプト
# macOS: say コマンドで日本語音声を m4a で生成
# Linux: Python で最小限のダミー WAV トーンを生成

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESOURCES_DIR="$PROJECT_ROOT/UzaoCalucurate/UzaoCalucurate/Resources"

mkdir -p "$RESOURCES_DIR"

echo "=== うざお電卓 効果音生成スクリプト ==="
echo "出力先: $RESOURCES_DIR"
echo ""

if command -v say &>/dev/null; then
    # ---- macOS ----
    echo "[macOS] say コマンドで音声を生成します"
    echo "[1/3] click.m4a を生成中..."
    say -v Kyoko -r 200 -o "$RESOURCES_DIR/click.m4a" "ポチッ"

    echo "[2/3] enter.m4a を生成中..."
    say -v Kyoko -r 120 -o "$RESOURCES_DIR/enter.m4a" "ドーン！"

    echo "[3/3] clear.m4a を生成中..."
    say -v Kyoko -r 200 -o "$RESOURCES_DIR/clear.m4a" "シュッ"

    ls -lh "$RESOURCES_DIR"/*.m4a
else
    # ---- Linux / CI ----
    echo "[Linux] say が見つかりません。Python でダミー WAV を生成します"
    python3 << 'PYEOF'
import struct, os, math

RESOURCES = os.environ.get("RESOURCES_DIR", ".")

def make_wav(path, freq=440, duration_ms=100, sample_rate=22050, volume=0.5):
    n_samples = int(sample_rate * duration_ms / 1000)
    samples = []
    fade = max(1, int(n_samples * 0.1))
    for i in range(n_samples):
        env = 1.0
        if i < fade:
            env = i / fade
        elif i > n_samples - fade:
            env = (n_samples - i) / fade
        val = volume * env * math.sin(2 * math.pi * freq * i / sample_rate)
        samples.append(int(val * 32767))
    data = struct.pack('<' + 'h' * len(samples), *samples)
    with open(path, 'wb') as f:
        f.write(b'RIFF')
        f.write(struct.pack('<I', 36 + len(data)))
        f.write(b'WAVE')
        f.write(b'fmt ')
        f.write(struct.pack('<IHHIIHH', 16, 1, 1, sample_rate, sample_rate*2, 2, 16))
        f.write(b'data')
        f.write(struct.pack('<I', len(data)))
        f.write(data)

make_wav(os.path.join(RESOURCES, "click.wav"),  freq=800,  duration_ms=60,  volume=0.6)
make_wav(os.path.join(RESOURCES, "enter.wav"),  freq=200,  duration_ms=200, volume=0.8)
make_wav(os.path.join(RESOURCES, "clear.wav"),  freq=1200, duration_ms=80,  volume=0.5)

for n in ["click.wav","enter.wav","clear.wav"]:
    p = os.path.join(RESOURCES, n)
    print(f"  {n}: {os.path.getsize(p)} bytes")
PYEOF
fi

echo ""
echo "=== 生成完了 ==="
echo ""
echo "NOTE: これらのファイルを Xcode で使用するには、"
echo "      Xcode > プロジェクトナビゲータ > Resources フォルダを右クリック"
echo "      > 'Add Files to \"UzaoCalucurate\"...' で手動追加してください。"
echo "      Target Membership にチェックが入っていることも確認してください。"
