class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.95.0",
      revision: "25cb64d67a297f7f45c0926a280f525e3cafd750"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29752347409bd4caf7d47654aa60e9fcddf6857c1d709ef16926edb31ea39724"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae9b4d5bffa69460e07ef7abed310883375d9daedae9d2b4c124bf77a42b080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9edd5790a0196936af1a2d412aecbcce386235688dcbc0bb22aeed7c04699a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e7139f3b7cb43d16858e9cfbe1626169784c762221d1f4e6b27746d8f56a53f"
    sha256 cellar: :any_skip_relocation, ventura:        "e95e3665ebeb126ba40a1a26f18d315fbf94a965ba328872e1c82e18cdda0dff"
    sha256 cellar: :any_skip_relocation, monterey:       "0aa6a4abe4a74ae62cb1feb9bda78d281b0d5d64a2cac8ba950a8877ff412195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362d057c212fd6807e9c966db1b5772ca065c4015dc90cca734f38ead639405a"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  # Remove extraneous `y` parameter from calls to `exp` and `logl`
  # upstream PR ref, https://github.com/diffblue/cbmc/pull/7985
  patch do
    url "https://github.com/diffblue/cbmc/commit/70151a9861c55a5156d85f73f8dce0554b4e0fac.patch?full_index=1"
    sha256 "e3c88c35af63b81df58b037dc101ab9205149ba8b5fe300294c9606b95d53206"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
