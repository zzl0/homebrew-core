class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.1.11.tar.gz"
  sha256 "e792d02c5613ef16cc6e988888a3379c9b4b931a8ed2e5d3f741a06c37a32f61"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e34d5ef14763389851c233b3f79446ab4bbc952cf81f06087686a3a0f7a8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b055aa3963664fca7ec055c5f5787d901f6671a4f8dbdb0d680842bb3899a5e8"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
