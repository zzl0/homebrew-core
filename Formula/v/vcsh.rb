class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.7/vcsh-2.0.7.tar.xz"
  sha256 "471e720420d1a8537284fd0f7e8a36ba99fbb78621e61c5380d2a632d698ff4f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4136305027b39b6c5106a8b598437be2700f60fea9ba422f5f58b3eb99a02cba"
  end

  def install
    # Set GIT, SED, and GREP to prevent
    # hardcoding shim references and absolute paths.
    # We set this even where we have no shims because
    # the hardcoded absolute path might not be portable.
    system "./configure", "--with-zsh-completion-dir=#{zsh_completion}",
                          "--with-bash-completion-dir=#{bash_completion}",
                          "GIT=git", "SED=sed", "GREP=grep",
                          *std_configure_args
    system "make", "install"

    # Make the shebang uniform across macOS and Linux
    inreplace bin/"vcsh", %r{^#!/bin/(ba)?sh$}, "#!/usr/bin/env bash"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
