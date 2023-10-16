require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.8.0.tgz"
  sha256 "75b7c494170bf07cee8616324fe12bd22cd2cfee2eeb34ae49ba8cbf98b6c55a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67de42b4336a861e627791947aec7a6a39b66d8c558346eb73b6a0ece6cce0d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67de42b4336a861e627791947aec7a6a39b66d8c558346eb73b6a0ece6cce0d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67de42b4336a861e627791947aec7a6a39b66d8c558346eb73b6a0ece6cce0d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bab09c119363c5979ba2a3946ee73bee518640662553e9e71fe1ece8884f1761"
    sha256 cellar: :any_skip_relocation, ventura:        "bab09c119363c5979ba2a3946ee73bee518640662553e9e71fe1ece8884f1761"
    sha256 cellar: :any_skip_relocation, monterey:       "bab09c119363c5979ba2a3946ee73bee518640662553e9e71fe1ece8884f1761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4330a906d906dc507926aa94eef3d5f10cfe0af85a2c6838d3954fafb3128cc"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
