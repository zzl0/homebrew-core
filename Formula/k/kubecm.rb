class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "6ce8802571be851e99603713cc638023776da0d2120cdc7d137a8e9319453f73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17fa72819b5c038d9dbc998802d4692ce472ff79326371e6e57774e1d55641ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07a6f76ad76707155a0a9f3389fd7ce42f5efbf5a465eaef319a5f6dc0ebc4a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7012444f92dc487213d8386a58d2d89f3472df83d8b9ce6da8ce9d0fb227a6c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "177de00661d2e4506b5dfe09c62a68677d64d6b3afb24b7478d00d0b5b74ca8e"
    sha256 cellar: :any_skip_relocation, ventura:        "4591d43610620156ee8977fe44edf8bd42ff1d052d20025c400efb8785cfd86e"
    sha256 cellar: :any_skip_relocation, monterey:       "dc1d7c9fd0e8394ac5beff4ff7778cacde2b4471d831f26a8ab3146d779fcdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf2554e629d2d12bc9c5853aca5d2e08b11ffbf467aa0812b26272e68dca79b"
  end

  depends_on "go" => :build

  # patch to use go1.21 for build
  # upstream pr ref, https://github.com/sunny0826/kubecm/pull/847
  patch do
    url "https://github.com/sunny0826/kubecm/commit/e8bcf31999e9629eb68174ee817b6f1c1b2951a3.patch?full_index=1"
    sha256 "63a48460535c857b804095eedea8d91c2dc42f76c9fd5d8004213dbdd6fe925f"
  end

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
