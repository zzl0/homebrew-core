class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "93d17e70cb33f7629bff5d18f6b92bf949216bb68bc29bf1bb93596d7ba78541"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3704e6f4371075c1042415c807e7b9dc102ba71a99050142cc71dc5d39d70ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf00b4290721858a1417705b5fad7bcf0430e62b860a90972d11107ad0de6358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec7ff041ff00782abb86e36b0363669a57bf5c35217556d4d48acfe08ead56a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec9f38ab631d55da4dcfcef1be6e125e1dee598bf289288ad6b41b9d614f0e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "2cb99a8a11df648082d8c01be701d45d0e15dd6041f019e1ebf741659b9e4e65"
    sha256 cellar: :any_skip_relocation, monterey:       "4646234f2e407036e6ebdfd9dd5922753d172792992e3b2e21f66f8a7f7559a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68e5b478ef92984d43d7c2080349198dfa18b460970b8dac79721816a449b77"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
