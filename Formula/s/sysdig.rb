class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.35.1.tar.gz"
    sha256 "9fbadcde35e7084d542edccafe6426b481a489698484d81587432b06024b2ca0"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.14.2.tar.gz"
      sha256 "b4ae7bbf3ad031deee4a808145f9fd64b71c537406cc5a92f512823b2e52cdd5"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "bd293374095ef5a411e240de2154e8d0cdb58d19923509b5915558c17592acaf"
    sha256                               arm64_ventura:  "bc7e403fc49cb136cfa3b74151486876727210df3ea8487b25f550d6b9be8056"
    sha256                               arm64_monterey: "eb9e99c38480f28bd23564d54acba365f79fcd5602293a63455a4e058a86a3d6"
    sha256                               sonoma:         "3719046b12379a2c1f6cbfc06b1f420191b76015649208bf6d17a072f62ca7ad"
    sha256                               ventura:        "51309acfa9b313b3f8a5ad830fa54d51de0eb4f8397ec7f782556be5d66b9f9b"
    sha256                               monterey:       "53c0e3c3ef473770ffa316c777dcfd97eed1332a923841733c2d5cb45083082c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c9e7b430323017db77eb6c8f53468265925976e8607a6f8b8843878df4e2a9"
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
  depends_on "uthash"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "abseil"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf"
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
      -DUSE_BUNDLED_TINYDIR=ON
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
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
