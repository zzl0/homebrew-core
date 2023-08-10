class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.32.1.tar.gz"
    sha256 "463ea62f3bc870b4dfaa5143abd6b790efb2219f86e8799792768d06de4169f9"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.11.3.tar.gz"
      sha256 "b4f9dc8c1612f4b14207d107bce323a0684dce0dbf018e5b846177992569367b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "2b3f77790dc4b4199130b78ac97505df9f2fb81b0818bf2a943a2e2438c48913"
    sha256                               arm64_monterey: "a245d55c643101ed62bf8caa1c36444d8c66d1d595b0cc4b781ec21ead7dd334"
    sha256                               arm64_big_sur:  "8afcfc9ca54fd422705f91e6d26beddc131c0b9735cf509cfc6b40dc24c52fa1"
    sha256                               ventura:        "b41766d7da6997647cc2b45c8d05b46eae5102a30b904da114d5a10f5b5772b1"
    sha256                               monterey:       "d2dd65f80f0b8c658fcc9e56e53243d1a4b5c3940c6429835e361b816764cd32"
    sha256                               big_sur:        "edc71218e74df73c24ebc131b10b04207321bf0bfbd4c3acf99c8dd8a761d5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42bb2635d57351e87c3b6e0c800c8177c997803e511a95e130a51a403bc0c599"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "valijson" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "re2"
  depends_on "tbb"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "abseil"
    depends_on "elfutils"
    depends_on "grpc@1.54"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf@21"
    depends_on "zstd"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # fix `libzstd.so.1: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
      -DCMAKE_CXX_FLAGS=-std=c++17
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
