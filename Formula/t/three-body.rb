class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.4.3.tar.gz"
  sha256 "58edbd7d163cbbd0268b1dc83f63f5cc0b8affcb649569fdfda39a977c373bc8"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b9e4471162a676994f5358b99ca83bbb2785505ddd39da4bbdb368c2f5bb8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4da6e6c28ffe7d41d4201d8f02cebc19b8a2f4e764cc118073dbd9f56f37d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c9cc10073d69e8e81c6e6bce6d70f4a669893eac9b96156af895e0ca628f16"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0952e387dcdbece6edfd0330d9a62152a952e2b2179522ca800cb54e28213fb"
    sha256 cellar: :any_skip_relocation, ventura:        "33aecfbdb3b4b1f1985803f1708c3cc1f8e3665207bbf062f42b48f64a8c73b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ae07e53f2ec7c5d2876019870f65e3d417fdae392564dc477b8f954e2b12d96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21158c287c3ebd4056319cb581a0176c03efb6aca9849af2d0559a32302775f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "\"文明\"", shell_output("#{bin}/3body -c '给 岁月 以 \"文明\"; 岁月'").strip
    assert_equal "\"生命\"", shell_output("#{bin}/3body -c '给 时光 以 \"生命\"; 时光'").strip
    assert_equal "Error(Can not assign to constant variable 水!)", shell_output("#{bin}/3body -c '
      思想钢印 水 = \"剧毒的\";
      水 = \"?\"'").strip
    assert_equal "4", shell_output("#{bin}/3body -c '给 自然选择 以 0; 自然选择 前进 4'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '给 宇宙 以 { \"维度\": 10 }; 宇宙.维度 降维 7'").strip
    assert_equal "true", shell_output("#{bin}/3body -c '这是计划的一部分'").strip
    assert_equal "false", shell_output("#{bin}/3body -c '主不在乎'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '
      给 水滴 以 法则() {
        给 响 = 0;
        return 法则() {
          响 = 响 + 1; 响
        }
      };
      给 撞 = 水滴();
      撞();
      撞();
      撞()'").strip
    assert_equal "\"半人马星系\"", shell_output("#{bin}/3body -c '给 三体世界坐标 以 \"半人马星系\"; 广播(三体世界坐标);'").strip
    assert_equal "", shell_output("#{bin}/3body -c '冬眠(1000); 二向箔清理(); 毁灭();'").strip
  end
end
