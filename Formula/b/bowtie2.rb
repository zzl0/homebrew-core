class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "4ac3ece3db011322caab14678b9d80cfc7f75208cdaf0c58b24a6ea0f1a0a60e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba123fa8a93030d6b58cfac75fe59181ac26eba4c1bfeb61b5cdb70f46d50dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8a2c3e9ac0b06294635f82daba8631b716c9961ea5862aca622e4843bc4179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a652099f2655a3226b7cd3032d104aab101e5825eb2eda836be68d4f7933d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "40ed790dc54e64ad10070c9cda63d3139b554aac85774865041e9493083e0df1"
    sha256 cellar: :any_skip_relocation, ventura:        "bc516df7a3a2b75e73d52536afa0dfe2b0ca5cc891796b0cc543166c5ce9b036"
    sha256 cellar: :any_skip_relocation, monterey:       "1302338c91cff1e603cefacc3f6a4a0e7cdca3aadf854837824d56eff907fbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328496c8d3b662a48f26dbd18532fbcf2f410a0a45df9875657a514e46c81966"
  end

  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_arm do
    depends_on "simde" => :build
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
