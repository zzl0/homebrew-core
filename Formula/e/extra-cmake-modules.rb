class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/extra-cmake-modules-5.113.0.tar.xz"
    sha256 "265e5440eebeca07351a469e617a4bf35748927bd907b00ace9c018392bb3bc4"
    depends_on "qt@5" => :build
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05942c3028a211f1237b2ed3bb8b21818547b48bffc678c3e63e416d8556786e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05942c3028a211f1237b2ed3bb8b21818547b48bffc678c3e63e416d8556786e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737761ce77066ec85da7e8e14769b359f28209f6d67f5a0f2badb5cf43d2544c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c03c564d8ffa98ca45b75cd309c94c017ebc065bf6e8efc6d5eca48951d6b6b4"
    sha256 cellar: :any_skip_relocation, ventura:        "5cff996e8ec4927e1d62bcb2fd6766013c0efaad29c5b8264c774d992fd353c7"
    sha256 cellar: :any_skip_relocation, monterey:       "5cff996e8ec4927e1d62bcb2fd6766013c0efaad29c5b8264c774d992fd353c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5688dd7f317b19cca71a4acd19c1698b858e2a4ad7fb7cb7fe2b7fee2e3916f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end
