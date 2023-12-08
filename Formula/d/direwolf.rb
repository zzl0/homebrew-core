class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.7.tar.gz"
  sha256 "6301f6a43e5db9ef754765875592a58933f6b78585e9272afc850acf7c5914be"
  license "GPL-2.0-only"
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"
  # Further investigation and work on this
  # formulae is needed to support linux builds. The upstream project
  # provides their own mechanism for linux distribution. Brew is most
  # valuable on macOS, where there is no other suitable package manager,
  # so for now, restrict this formulae to macOS.
  depends_on :macos
  depends_on "portaudio"

  def install
    inreplace "src/decode_aprs.c", "/opt/local/share", share
    inreplace "src/symbols.c", "/opt/local/share", share

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--build", "build", "--target", "install-conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direwolf -u")

    touch testpath/"direwolf.conf"
    assert_match "Pointless to continue without audio device.", shell_output("#{bin}/direwolf brew", 1)
  end
end
