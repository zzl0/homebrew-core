class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.9.0/bashunit"
  sha256 "c28db170b8d817cf995584be5039c96c9a23202df638eb36f139ca598e461f61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "415c601e63ba36c9c8523e5c204e92743ab4c4976acad5d4e3779b42034f2cc9"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    EOS
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
