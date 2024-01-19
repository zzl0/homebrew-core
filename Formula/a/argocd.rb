class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.9.5",
      revision: "f9436641a616d277ab1f98694e5ce4c986d4ea05"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "275b02405d14eb0217fe0a04c9a8f27461ae5888997fb5f346c2e67f52bd03a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2791f041f76dbf339b87863b281fc2d6a729c2b050af5301849c276172a1ec6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "923873e07e8481987cedc73699411ca6f882fe0f5a1796bf6f9ae5ddacf869d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e7f344a95e7a8ca7b4f090743277e7884b69e4c9c14709321c19db3840667a3"
    sha256 cellar: :any_skip_relocation, ventura:        "57ffb1a2b1a13573627a32d901eff2585d5d5e800ac06b9665aff2c5dd2bc6aa"
    sha256 cellar: :any_skip_relocation, monterey:       "665f30eba82c8f39056f9dbc9f398dab6e4fe3ed1476ae4800419e633cd5708f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b7d7f71944a5a8b8fed80be5cea4db4dc1abd8ebd7a8d571ba02def43d7eab"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
