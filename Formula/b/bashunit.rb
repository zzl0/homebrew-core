class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.10.0/bashunit"
  sha256 "85ff586925cd48c1866b236386e209ebbd266a950f35927cc7fe441b839d4606"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81938bb017a2bb3a053b5846b1a3bc45629676ceb5203fba5c7842f559431042"
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
