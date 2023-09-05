class Antlr < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr-4.13.1-complete.jar"
  sha256 "bc13a9c57a8dd7d5196888211e5ede657cb64a3ce968608697e4f668251a8487"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr[._-]v?(\d+(?:\.\d+)+)-complete\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, ventura:        "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, monterey:       "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, big_sur:        "95ba0df129985acbf0514ce3c98ac9d4ed5e95fba9aabc8cc153e5e714f5e597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a4884ec0c11d31a3c36344dcae35a33d761a9fade4bc779c93caebd1450545"
  end

  depends_on "openjdk"

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr").write <<~EOS
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec "#{Formula["openjdk"].opt_bin}/java" -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    EOS

    (bin/"grun").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.gui.TestRig "$@"
    EOS
  end

  test do
    path = testpath/"Expr.g4"
    path.write <<~EOS
      grammar Expr;
      prog:\t(expr NEWLINE)* ;
      expr:\texpr ('*'|'/') expr
          |\texpr ('+'|'-') expr
          |\tINT
          |\t'(' expr ')'
          ;
      NEWLINE :\t[\\r\\n]+ ;
      INT     :\t[0-9]+ ;
    EOS
    ENV.prepend "CLASSPATH", "#{prefix}/antlr-#{version}-complete.jar", ":"
    ENV.prepend "CLASSPATH", ".", ":"
    system "#{bin}/antlr", "Expr.g4"
    system "#{Formula["openjdk"].bin}/javac", *Dir["Expr*.java"]
    assert_match(/^$/, pipe_output("#{bin}/grun Expr prog", "22+20\n"))
  end
end
