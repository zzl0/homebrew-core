class Apprise < Formula
  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/71/c5/07b2749256c9e14d062c7f48b59bda176644ace52ae94153b22ee6fadb1b/apprise-1.6.0.tar.gz"
  sha256 "3eefab1c5d7978b0e65c5091d1cdbe9206865dc3cb5d19ca5cfbddb76e8aaffe"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e3cc51405039f4d591b9722268a15e7faa0e96014aef9ddaccc6f209d680ffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c5ee6bef723d95fe4bd485d111f92ce9b08121cb8f459d9bb3352442ebef011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95f95ec6528a58a4a3750748986a3d614d56c5504fd8888a038f8b74370980f"
    sha256 cellar: :any_skip_relocation, sonoma:         "af0b32c3dd31dc7081d47897e7c68e18477ec5b730125b3b4daaa374e27373c1"
    sha256 cellar: :any_skip_relocation, ventura:        "6e7368c87ff3a3715397bf9ebe7fc59f142c6ee3afac1d94c3e0e856fe0c83b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7c4d6044ae06bb4cb6be70f4a5a8190adf39524550e5194113e9fa103e83a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55408ba1fc2a9a62f6342b0d490706796070ee4beb4b068ec6b3317e4245f86c"
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
