class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/2c/73/13f76208c9e6312e27bd6d5f62ff867746b7c075b9451448803dc13b2834/rpl-1.15.5.tar.gz"
  sha256 "ae13d2fa1c1b8eaab75ff5756cbea9cc6836b55c4191e332521682be69de1b83"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e748fcb997a9f4173d55a618c5bd76db037c8c89ab87f3b49af797dc1c92ecbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33bdfb7ac03b2f0bc8fa9744ce91ff3bcab8e95f729b219f2c52796ed3039b5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8260d9b4929478ebb46333397ceaa14b54908f1ad54237eeff07398e76c4c06d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b45f7e45719d16c8181411f29f330251bf20a0e4af946c76653f386307ffefa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c03e8e4350ee2d87d9165131353ccf39438d648088411b6ea00c47b21f3ee360"
    sha256 cellar: :any_skip_relocation, ventura:        "bc7e9093f065ce21c4453a4672dbbfe711552cd8307ad3996f7926e68d030c0f"
    sha256 cellar: :any_skip_relocation, monterey:       "87d755ad01e755e32f8d67bfe5a4a005ecfcf8c2117e813e195d4c624ca7732f"
    sha256 cellar: :any_skip_relocation, big_sur:        "416a16df6f81200d1ece3520963a6d77cc82330d91f760566436c76b6a4bf5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b3e52f32e8819483105ea0e5b94674e7019b92b02ae8207f4387296fcd7af9"
  end

  depends_on "python@3.12"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
