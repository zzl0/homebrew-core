class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "ec4284c917f2abf1f952a1dd4c57f3c33b7809d0e2fd5482472e1b1abbba45ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6468e002f64c0dbd82f809d92d2b3839e932726cb3d0db6f841271f1a818965d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6468e002f64c0dbd82f809d92d2b3839e932726cb3d0db6f841271f1a818965d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6468e002f64c0dbd82f809d92d2b3839e932726cb3d0db6f841271f1a818965d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fe550a3299512c8af4f1bfeb1e36f066aad0e99fbc26bd857d4213450f0d4cc"
    sha256 cellar: :any_skip_relocation, ventura:        "2fe550a3299512c8af4f1bfeb1e36f066aad0e99fbc26bd857d4213450f0d4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe550a3299512c8af4f1bfeb1e36f066aad0e99fbc26bd857d4213450f0d4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87b4243b510171779dc2b390287cbf98e60c1e594b1168908cd580272084e7b2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
