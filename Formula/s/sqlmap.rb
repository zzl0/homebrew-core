class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.10.tar.gz"
  sha256 "75a9fb2c8e64292baf1380d75ce4024eed7a9763375748042015bc401e784c78"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "629a6288ed42f61220a1686d43323542a2377142839117fda7db11654c216072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629a6288ed42f61220a1686d43323542a2377142839117fda7db11654c216072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629a6288ed42f61220a1686d43323542a2377142839117fda7db11654c216072"
    sha256 cellar: :any_skip_relocation, sonoma:         "bffeac0ff40484deeffdd1198678f2ca1554dddb3b8f8ffaded009bf11fff512"
    sha256 cellar: :any_skip_relocation, ventura:        "bffeac0ff40484deeffdd1198678f2ca1554dddb3b8f8ffaded009bf11fff512"
    sha256 cellar: :any_skip_relocation, monterey:       "bffeac0ff40484deeffdd1198678f2ca1554dddb3b8f8ffaded009bf11fff512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee375f9e3001f906f39239adfb85e0bd366c725cd13c8e05a01da0674fa31a02"
  end

  depends_on "python@3.12"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
