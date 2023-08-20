class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "f2db7e3c7a316499a8bf118d23ec73905f5f6b2b4e9a4b8a00d84a322cb33a8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e467733f8b35943b10fcf40dccf5865dc178aa7c3c74cd5eaf44b3a36684c63"
  end

  depends_on "go" => :build

  # patch version fix, remove in next release
  # upstream PR ref, https://github.com/zeromicro/go-zero/pull/3509
  patch do
    url "https://github.com/zeromicro/go-zero/commit/cafbafb.patch?full_index=1"
    sha256 "750a2433412f7734208b796ecabec51f91c852f4e6fb39e103f02c874fd16214"
  end
  # patch do
  #   url "https://github.com/zeromicro/go-zero/commit/a9bb45a.patch?full_index=1"
  #   sha256 "6ca36aed9192ef35fa9baf3141fd2bea1adbba3221fa443464883f44383a5dca"
  # end

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
