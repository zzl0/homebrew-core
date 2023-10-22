class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e5cee591093f1db9b553998b1d334c7833d52fb847a360d56af11a9f6b40f3ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81dd11656635d8614a77a3689936ff3f8f1ea23d4be82ab693dcade73048b0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5336400c90f0775873fb8fd743766ca1abc863323c6e41f87622c0c0ec550727"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd40175943ce76ac19f7c98028680f88f39f182e60f4d6a41c770cb56fcf766"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8a66acdc0b88bcc3e1ae7e291cb4c707a4fb626628ea3f5e06226026cdb2823"
    sha256 cellar: :any_skip_relocation, ventura:        "58beed345842bbce9ac06abc1478618aa66e6ac61836a562a97ad31591dc16b1"
    sha256 cellar: :any_skip_relocation, monterey:       "b57ff73e730e0f7a949a84b89890bc95249443bc44f6e2c9ff0c5f0718131556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee081625bd1c87174aef88f7de8eaad311d0e905d46029369c83e8101e82a59b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end
