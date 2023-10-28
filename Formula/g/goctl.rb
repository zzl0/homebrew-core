class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.0.tar.gz"
  sha256 "69bd7ede2c65d3da66929220d9a2c44979732c383bfc064182250c48f3c27b7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0336d3d2cff06e5adaf07e9a2d3919efc2ec04a8a533021bd4991967d04c9a5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99896cb88a3a9640eb32f59392c625ab51da922c3bd0182c5d79a8e2baf3ffbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb18d2ba590f577162fbff432b3a6d9dabd933fb3f07d499f6712be2dbca45f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c0d29a95085eb98c2612ac03409784333fbd2cf1aba6e4508cf98a077936b4b"
    sha256 cellar: :any_skip_relocation, ventura:        "769d6c3a92ac78e5f99beb348b7c09109f2936c7b94187061b071d254f1e4bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "db698bb773fdcd92e775b6bfce90e283ffbb4e33c39462eae096545417b36258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25011b00f686b7f8a9ee8183b6bccc8ff8e9a3721717df5e0353e74e42dffa5"
  end

  depends_on "go" => :build

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
