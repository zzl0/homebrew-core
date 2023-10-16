require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.8.1.tgz"
  sha256 "c82ca1a7ecf175b22db864b4d5e936c4821bf37a81b74535002c19ab5e302407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "416b338a655cf8ad78ded8e94ea550c922183e7993f4a498add92455ce623a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "416b338a655cf8ad78ded8e94ea550c922183e7993f4a498add92455ce623a5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416b338a655cf8ad78ded8e94ea550c922183e7993f4a498add92455ce623a5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b7ed346cd7d5af883287a5a222d7e7aefbda24729b81e13683af9dc62202d73"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7ed346cd7d5af883287a5a222d7e7aefbda24729b81e13683af9dc62202d73"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7ed346cd7d5af883287a5a222d7e7aefbda24729b81e13683af9dc62202d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5b303ced3d4b53d12101651644a12520af16df24233fab6f23f66bf528dc0f"
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
