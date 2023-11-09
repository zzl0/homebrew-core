require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.7.1.tgz"
  sha256 "a5dc54d7e4cc36c8fa68ab6312a24cfd1ad44decb2280e840e54b95cee96ea42"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, ventura:        "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, monterey:       "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
