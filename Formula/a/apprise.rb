class Apprise < Formula
  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/9c/24/24356d021be60b63c96248a2202153932bfa6c6dee6c29a36e86e9cd7c78/apprise-1.7.0.tar.gz"
  sha256 "d8d5710d3c952586c2cfadf7ce9ea0fe60b80eca93946497e3ef18f3cc0eec19"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cf4b0d4008e2a6c7468886fa3377fbeda729ab5bdc239ec79084a0604e8b2b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820129bda981c02804c17fcc33398b09e41c833173792e9cb9aef98006604934"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b88057c0ffa8d8f584a08d23bd2b0140113df2e551a749996baf24edb65c91dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "69a98b560c80d803c466aa9dfe76c9371f5e8a5a011a3e520495f914027a7d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "93439ba73a31a94e8d2b628c853180e5f07f043cb040b550691efe1ccfb73c68"
    sha256 cellar: :any_skip_relocation, monterey:       "615deebe0c0ac57676ff43a13be52f0bcb86932be00a8b8fbdb6ff9f6066bb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f2cb9b129f026ddee79495eec0f6d2ed59ae8ca0caf7bd01ff424dbe21ad88"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-markdown"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    brewtest_notifier_file = "#{testpath}/brewtest_notifier.py"
    apprise_plugin_definition = <<~EOS
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    EOS

    File.write(brewtest_notifier_file, apprise_plugin_definition)

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    brewtest_notification_title = charset.sample(32).join
    brewtest_notification_body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match \
      "#{brewtest_notification_title}: #{brewtest_notification_body}", \
      shell_output(
        "#{bin}/apprise" \
        + " " + %Q(-P "#{brewtest_notifier_file}") \
        + " " + %Q(-t "#{brewtest_notification_title}") \
        + " " + %Q(-b "#{brewtest_notification_body}") \
        + " " + '"brewtest://"' \
        + " " + "2>&1",
      )
  end
end
