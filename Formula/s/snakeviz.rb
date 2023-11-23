class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/64/9b/3983c41e913676d55e4b3de869aa0561e053ad3505f1fd35181670244b70/snakeviz-2.2.0.tar.gz"
  sha256 "7bfd00be7ae147eb4a170a471578e1cd3f41f803238958b6b8efcf2c698a6aa9"
  license "BSD-3-Clause"

  depends_on "python@3.12"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/snakeviz", "--version"

    port = free_port

    pid = fork do
      exec "#{bin}/snakeviz", "--port", port.to_s, "--server", "."
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/")
    assert_match "SnakeViz", output
  ensure
    Process.kill("HUP", pid)
  end
end
