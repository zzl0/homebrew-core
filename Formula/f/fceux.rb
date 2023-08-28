class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"

  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd40795/fceux/2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29c17d2846c4209b08c59d20f1dd79326c6bb7b59155e8cf1d3b0b28943fcd9d"
    sha256 cellar: :any,                 arm64_ventura:  "b6c7083d0ff87dd94a6df0ea89d64af36a388f3d9c3e1d4b6a3ab2e860470a06"
    sha256 cellar: :any,                 arm64_monterey: "7de6bc6220bb9deb784a968a8b0372b73d3e423dd04f4195b735ac6efe385b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "776b1e2ad2c87f247b5197d592adc786dbab9c4fa72fc3804a9438b9b44c057c"
    sha256 cellar: :any,                 sonoma:         "dd5d643659e560f7aaa982afa2572efe8705eaaa8f30f0750915d3fa02a6e7ae"
    sha256 cellar: :any,                 ventura:        "669f8328acb34528c9c04751487f6c322e255c3525d264dc7dd49a811227ccb0"
    sha256 cellar: :any,                 monterey:       "ab2273111bff299b8c43de29ee7653c3ebeacebe62952e312b03e0174b83032f"
    sha256 cellar: :any,                 big_sur:        "76236a742cc5542b5128ed2f939fcea0ac8c627de7545adc4beb7489bf0e019d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6de0ff7889ad3bcbd933c6f433651078c74afa57ffe7e1d575fde42aa53a806d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/fceux", "--help"
  end
end
