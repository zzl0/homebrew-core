class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "6.18.1",
      revision: "a1580f9cdf331c35dceb486f4231871ce0b00266"
  license "LGPL-2.1-or-later"
  revision 5
  head "https://github.com/csound/csound.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "23408b1ab3e0d8eac84404c50e3007cee39707a603ed8115d6fb75b63d4bb299"
    sha256 arm64_ventura:  "ae00909300c6c3b125438325cd6e58d2d49ca19916764a7bee05ff60b54c5cb8"
    sha256 arm64_monterey: "f8c2fe6e9f9e6c0b972a038e6decf86238ba8dbb2cc055b6cd092f6bfa198791"
    sha256 sonoma:         "2d1a08d8e93073cd082ba0a7933391df6a6a550da98cbab8da0996f81ef11b99"
    sha256 ventura:        "d37e8023fab2d933fce945e26d6b7f6a2bc563ecf18a0f541e4d16b460dbc177"
    sha256 monterey:       "e70c674d6951aa1fc5f352dac36bc628e90cecb46b264dbeaa3398ccfee2f338"
    sha256 x86_64_linux:   "57f0472055f8ecbc797be1228c230885f08e41026cab0777ec4885630343f307"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "swig" => :build
  depends_on "faust"
  depends_on "fltk"
  depends_on "fluid-synth"
  depends_on "gettext"
  depends_on "hdf5"
  depends_on "jack"
  depends_on "lame"
  depends_on "liblo"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libwebsockets"
  depends_on "numpy"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.12"
  depends_on "stk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "wiiuse"
  end

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  fails_with gcc: "5"

  resource "ableton-link" do
    url "https://github.com/Ableton/link/archive/refs/tags/Link-3.1.0.tar.gz"
    sha256 "6a9e70a70b5ea1d8825f6b2f34085f8e3e52d0581a62e6eb3f72de168c1a13bc"
  end

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/refs/tags/1.0.2.tar.gz"
    sha256 "8c2f0625ad1d38400030f414b92d82cfdec5c04b7dc178852f3e1935abf75d30"

    # Fix build on macOS 12.3+ by replacing old system Python/Python.h with Homebrew's Python.h
    patch do
      url "https://github.com/csound/plugins/commit/13800c4dd58e3c214e5d7207180ad7115b4e2f27.patch?full_index=1"
      sha256 "e088cc300845408f3956f070fa34a900b700c7860678bc6d37f7506d615787a6"
    end
  end

  resource "getfem" do
    url "https://download.savannah.gnu.org/releases/getfem/stable/getfem-5.4.2.tar.gz"
    sha256 "80b625d5892fe9959c3b316340f326e3ece4e98325eb0a81dd5b9ddae563b1d1"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DBUILD_JAVA_INTERFACE=ON",
                    "-DBUILD_LUA_INTERFACE=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
                    "-DPYTHON3_MODULE_INSTALL_DIR=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"
      site_packages.install buildpath/"interfaces/ctcsound.py"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin/"srconv").unlink
    end

    resource("csound-plugins").stage do
      resource("ableton-link").stage buildpath/"ableton-link"
      resource("getfem").stage { cp_r "src/gmm", buildpath }

      args = %W[
        -DABLETON_LINK_HOME=#{buildpath}/ableton-link
        -DBUILD_ABLETON_LINK_OPCODES=ON
        -DBUILD_CHUA_OPCODES=ON
        -DBUILD_CUDA_OPCODES=OFF
        -DBUILD_FAUST_OPCODES=ON
        -DBUILD_FLUID_OPCODES=ON
        -DBUILD_HDF5_OPCODES=ON
        -DBUILD_IMAGE_OPCODES=ON
        -DBUILD_JACK_OPCODES=ON
        -DBUILD_LINEAR_ALGEBRA_OPCODES=ON
        -DBUILD_MP3OUT_OPCODE=ON
        -DBUILD_OPENCL_OPCODES=OFF
        -DBUILD_PYTHON_OPCODES=ON
        -DBUILD_STK_OPCODES=ON
        -DBUILD_WEBSOCKET_OPCODE=ON
        -DGMM_INCLUDE_DIR=#{buildpath}
        -DPython3_EXECUTABLE=#{python3}
        -DUSE_FLTK=ON
      ]
      args += if OS.mac?
        %W[
          -DBUILD_P5GLOVE_OPCODES=ON
          -DBUILD_WIIMOTE_OPCODES=ON
          -DCSOUND_FRAMEWORK=#{frameworks}/CsoundLib64.framework
          -DCSOUND_INCLUDE_DIR=#{frameworks}/CsoundLib64.framework/Headers
          -DPLUGIN_INSTALL_DIR=#{frameworks}/CsoundLib64.framework/Resources/Opcodes64
        ]
      else
        %w[
          -DBUILD_P5GLOVE_OPCODES=OFF
          -DBUILD_WIIMOTE_OPCODES=OFF
        ]
      end

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  def caveats
    caveats = <<~EOS
      To use the Java bindings, you may need to add to your shell profile
      e.g. ~/.profile or ~/.zshrc:
        export CLASSPATH="#{opt_libexec}/csnd6.jar:."
      and link the native shared library into your Java Extensions folder:
    EOS

    on_macos do
      caveats = <<~EOS
        #{caveats}\
          mkdir -p ~/Library/Java/Extensions
          ln -s "#{opt_libexec}/lib_jcsound6.jnilib" ~/Library/Java/Extensions
      EOS
    end

    on_linux do
      caveats = <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv

        #{caveats}\
          sudo mkdir -p /usr/java/packages/lib
          sudo ln -s "#{opt_libexec}/lib_jcsound6.jnilib" /usr/java/packages/lib
      EOS
    end

    caveats
  end

  test do
    (testpath/"test.orc").write <<~EOS
      0dbfs = 1
      gi_peer link_create
      gi_programHandle faustcompile "process = _;", "--vectorize --loop-variant 1"
      FLrun
      gi_fluidEngineNumber fluidEngine
      gi_realVector la_i_vr_create 1
      pyinit
      instr 1
          a_, a_, a_ chuap 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          a_signal STKPlucked 440, 1
          a_, a_ hrtfstat a_signal, 0, 0, sprintf("hrtf-%d-left.dat", sr), sprintf("hrtf-%d-right.dat", sr), 9, sr
          hdf5write "test.h5", a_signal
          mp3out a_signal, a_signal, "test.mp3"
          out a_signal
      endin
    EOS

    (testpath/"test.sco").write <<~EOS
      i 1 0 1
      e
    EOS

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
      ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      ENV["OPCODE6DIR64"] = lib/"csound/plugins64-6.0"
      ENV["SADIR"] = share/"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare/"rawwaves"

    system bin/"csound", "test.orc", "test.sco"

    assert_predicate testpath/"test.#{OS.mac? ? "aif" : "wav"}", :exist?
    assert_predicate testpath/"test.h5", :exist?
    assert_predicate testpath/"test.mp3", :exist?

    (testpath/"opcode-existence.orc").write <<~EOS
      JackoInfo
      instr 1
          i_ websocket 8888, 0
      endin
    EOS
    system bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"

    if OS.mac?
      (testpath/"mac-opcode-existence.orc").write <<~EOS
        instr 1
            p5gconnect
            i_ wiiconnect 1, 1
        endin
      EOS
      system bin/"csound", "--orc", "--syntax-check-only", "mac-opcode-existence.orc"
    end

    system python3, "-c", "import ctcsound"

    (testpath/"test.java").write <<~EOS
      import csnd6.*;
      public class test {
          public static void main(String args[]) {
              csnd6.csoundInitialize(csnd6.CSOUNDINIT_NO_ATEXIT | csnd6.CSOUNDINIT_NO_SIGNAL_HANDLER);
          }
      }
    EOS
    system Formula["openjdk"].bin/"javac", "-classpath", "#{libexec}/csnd6.jar", "test.java"
    system Formula["openjdk"].bin/"java", "-classpath", "#{libexec}/csnd6.jar:.",
                                          "-Djava.library.path=#{libexec}", "test"
  end
end
