class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://github.com/ysugimoto/falco/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "a118b1038221fb999f654572c992f7be447805644a5f9b3144db27ce4693b78a"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61651faafd791ca01e607154b90a16b4fb57d91dca72085c86568c8c2bf64069"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28c9c1ed96276a2eae9721cadb5fd7787ec5c69abaa04e8735e2be0b7422c0d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1daca84c9a26bc6a013916a958abfed06d64df713aea71b50a7bec8ad205399"
    sha256 cellar: :any_skip_relocation, sonoma:         "197716abdfdf2c2e45bc69a0ba56c6152009bdc2f7540b9cf5e867d514ed2224"
    sha256 cellar: :any_skip_relocation, ventura:        "b1aad5ee374b2a728605150768790ba954908cc04d055c6666470575178d060e"
    sha256 cellar: :any_skip_relocation, monterey:       "b2912b2f103c2a3d3cc2349568b9c6b76c805864a9c073878c0007f1c2006c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce1ccee5c322d51202c6b239f49ca589309edd01ce4dfd1b36adcbb23a4e11e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1", 1)

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end
