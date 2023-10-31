class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/llvm-17.0.4.src.tar.xz"
    sha256 "4f5907fb547947d10df35230a0fc73cf2f81aa12e09fc8de96c023425412c9f6"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/clang-17.0.4.src.tar.xz"
      sha256 "56c99515be2f245848dacc60fe85fe9de66cdc438ea0a1b82640e68384d0e432"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/cmake-17.0.4.src.tar.xz"
      sha256 "1a5cbe4a1fcda56ecdd80f42c3437060a28c97ec31de1748f6ba6aa84948fb0f"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/third-party-17.0.4.src.tar.xz"
      sha256 "49358a7da2f49149a3028bf3aa6389052d4ebc15c548699cf19694141fdea847"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88fe7ab9e45a771fe78c915bf4a13cfea7da29c5a2ce7f56061d967a2248fa7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6434fe4684f9be5700bd93392f39b0dd2b1802bd89a1b4fade2beae43b2e579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8152d605ef84b567c7c91343a01f1e0a558f43b6799df5a942e049a3826db5"
    sha256 cellar: :any_skip_relocation, sonoma:         "558573ffa9b8295dfda5224807b5a6b919335ad31a1905fbb74e085c94155848"
    sha256 cellar: :any_skip_relocation, ventura:        "5ceca5c06792b6ccebd1ef92b2a08bfb8d38d28b4359953f586193ca63c1bd64"
    sha256 cellar: :any_skip_relocation, monterey:       "cd435f7b1a7104323df8561fdab560ec981efda0100074e54cba90439b2384e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c4885de4af5b78c6865db8532e84f23f0b2c836acc7d2cbdd377da52b7bba2"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
