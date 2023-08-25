class Counts < Formula
  desc "Tool for ad hoc profiling"
  homepage "https://github.com/nnethercote/counts"
  url "https://github.com/nnethercote/counts/archive/refs/tags/1.0.3.tar.gz"
  sha256 "1cbe4e5278b8f82d7b6564751e22e96fac36c5b5ee846afd1df47e516342e031"
  license "Unlicense"
  head "https://github.com/nnethercote/counts.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write <<~EOS
      a 1
      b 2
      c 3
      d 4
      d 4
      c 3
      c 3
      d 4
      b 2
      d 4
    EOS

    output = shell_output("#{bin}/counts test.txt")
    expected = <<~EOS
      10 counts
      (  1)        4 (40.0%, 40.0%): d 4
      (  2)        3 (30.0%, 70.0%): c 3
      (  3)        2 (20.0%, 90.0%): b 2
      (  4)        1 (10.0%,100.0%): a 1
    EOS

    assert_equal expected, output

    assert_match "counts-#{version}", shell_output("#{bin}/counts --version", 1)
  end
end
