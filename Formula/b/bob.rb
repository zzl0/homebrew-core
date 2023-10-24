class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "05ac4956812d5cde18cf4059f0e5ce92a0556bf7a78bd487eec8670d235a4617"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system "#{bin}/bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system "#{bin}/bob", "erase"
  end
end
