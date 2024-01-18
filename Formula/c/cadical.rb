class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.3.tar.gz"
  sha256 "4ae1ecdf067e7fd853f69105f4324de65f52552ce2efb6decb170c8924c4e070"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12a6ba5e47163f21c2adea4a9c24d54ec718eaf15814a8b9fb50f3fb7a405536"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da25027f1b1d1a05961ac36d35e5ce300e6da4ffc363af51704d9b814b3a70e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c65f2b7b8a5779aa2de566b87ebf742f32e91580cb2e24361b713892576c8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "22f7cd2152275b6ada552d02bc2368a6fe2165f0b6326fc33a7a01f359a0db1b"
    sha256 cellar: :any_skip_relocation, ventura:        "c60eafb731dd91d5a445580b4293eebd4cfd53facda4bf9633bcdff5229314cb"
    sha256 cellar: :any_skip_relocation, monterey:       "215968a1857596651a10aa52518389ffdd0b8afac93c755d4fd816625238db8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eddc91fcce428dad58af47c8e7a685295bba5eeab08f53fb0490ec3f332f270"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

    system "./configure"
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "../src/cadical.hpp"
      include.install "../src/ccadical.h"
      include.install "../src/ipasir.h"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cadical simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.cpp").write <<~EOS
      #include <cadical.hpp>
      #include <cassert>
      int main() {
        CaDiCaL::Solver solver;
        solver.add(1);
        solver.add(0);
        int res = solver.solve();
        assert(res == 10);
        res = solver.val(1);
        assert(res > 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
