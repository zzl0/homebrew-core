class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/refs/tags/v12.7.5.tar.gz"
  sha256 "a4d30e37c0c894214b941b51184723e19d492118c946cfdeac74b6d1f0068016"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "16652027516a9e6f1785f448087761de1c2e86fb3717e00bb9b8ebe1ec02daf6"
  end

  depends_on :linux

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--prefix=#{prefix}",
           "conf_dir=#{etc}/sysconfig",
           "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
