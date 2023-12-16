class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/ki18n-5.113.0.tar.xz"
    sha256 "fc94ba4cd1a4f0d25958764efcfc052cbf29fcf302cd668be2b18f62c6c58042"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d841eb9fe44f81f1a85c65ff75866b1ba94bacd8499d17dd057709c19768b67"
    sha256 cellar: :any,                 arm64_ventura:  "55af29ff56fb4c3f2962b608c905b36c07008b48e7ab0af9e755a8ee2ee2efee"
    sha256 cellar: :any,                 arm64_monterey: "5837f9757264b0bb88a11183c3496b2da026dd7930f31657ccf9a10a0f8bc463"
    sha256 cellar: :any,                 sonoma:         "e5fea5c336856deda5705bc1c1d73ba62dd85bd66ba3950840f18f0eacf70658"
    sha256 cellar: :any,                 ventura:        "305d36763c239529140420a6de17525fd55e0ceeb65b4275cbe395616eb9aac1"
    sha256 cellar: :any,                 monterey:       "5c766ad27d7cd7dfc9bf3515ba115e6a506a250c4ad74b89fbbf4e2cd4dbe431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd6a90d20224d621690f7f18fb4b76dfe4b6e65c75d2d8354b687c7d9ad1d20d"
  end

  head do
    url "https://invent.kde.org/frameworks/ki18n.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "iso-codes"

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5"

  def install
    # TODO: Change to only use Python3_EXECUTABLE when KDE 6 (Qt 6) is released
    python_variable = build.head? ? "Python3_EXECUTABLE" : "PYTHON_EXECUTABLE"

    args = %W[
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
      -D#{python_variable}=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    qt = Formula[build.head? ? "qt" : "qt@5"]
    qt_major = qt.version.major

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version unless build.head?} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      set(CMAKE_CXX_STANDARD 17)
      set(QT_MAJOR_VERSION #{qt_major})
      set(BUILD_WITH_QML ON)
      set(REQUIRED_QT_VERSION #{qt.version})
      find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED Core Qml)
      find_package(KF#{qt_major}I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = %W[-DQt#{qt_major}_DIR=#{qt.opt_lib}/cmake/Qt#{qt_major}]
    if OS.mac?
      args += %W[
        -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
        -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end
