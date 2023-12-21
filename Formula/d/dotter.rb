class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "b017b8315a76bf62b2e8e65217d487ad88b73fc18110a679076e6ad6e3936c40"
  license "Unlicense"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotter", "gen-completions", "-s")
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/".dotter/local.toml").write <<~EOS
      packages = ["xxx"]
    EOS
    (testpath/".dotter/global.toml").write <<~EOS
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    EOS

    system bin/"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end
