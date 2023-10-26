class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.17.0/source/quick-lint-js-2.17.0.tar.gz"
  sha256 "8a7ed7f7bcc664da23b7d112bf03d0cdc747aed62d5ba0f466ce1c2998e94966"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e67ff087d4f2a3c23917403a863ae9e402e4e64f2d441700f395186e392c0ed1"
    sha256 cellar: :any,                 arm64_monterey: "bbaf3b5d9a5aebb94067fe8ecc9daeecf132458ab8ac85ad8208202365b0da13"
    sha256 cellar: :any,                 ventura:        "4757ba375e8b723af50d528adca9da856560d6d59dd568e8f7c7c3fe0f2a598f"
    sha256 cellar: :any,                 monterey:       "b24af757d3a1d437ffa1150f80b3139fab13725af83b36cfe6d240d92b911dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089fd1490c147d1c3e76e850f7e90c97e4f5139bba64c28ef3eb8531ab6718ee"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}/quick-lint-js errors.js"
    output = `#{bin}/quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
