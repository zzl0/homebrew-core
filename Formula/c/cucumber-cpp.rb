class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.7.0",
      revision: "ceb025fb720f59b3c8d98ab0de02925e7eab225c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08ed8ef1c3b721d385eae4267c2af54ae1117fd8271bf91c9f671cb482f5b7a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac3ab97c6baf4543b358259c8f17654d2d0c977c5a4c374ae325d2ca78c7b5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c567b4e99c1f34f5ab6ef8bfe3dfe59a7f4b1849b3969a667032c60904ef221"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeb3a31c4dbd91b2a44f4bd0c2885c3e0b6800847953b80a1e79eb015be55374"
    sha256 cellar: :any_skip_relocation, ventura:        "4531fdd346511c18ae83cfaed4e897773657e8bad863629249ac98af73505512"
    sha256 cellar: :any_skip_relocation, monterey:       "09e8aaf01c142cf7f56b6a55eaffa08a88b1f161800b569edd66b29005d2a678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b6491da0c2c4baf8bf080358135c4139cac035e7ee083c4575b11d4000f721"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "qt@5" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  def install
    args = %w[
      -DCUKE_DISABLE_GTEST=on
      -DCUKE_ENABLE_EXAMPLES=on
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install "examples"
  end

  test do
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath

    system "gem", "install", "cucumber:9.1.1", "cucumber-wire:7.0.0", "--no-document"

    (testpath/"features/test.feature").write <<~EOS
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    EOS
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"features/support/wire.rb").write <<~EOS
      require 'cucumber/wire'
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS

    cxx_args = %W[
      -std=c++17
      test.cpp
      -o
      test
      -I#{include}
      -L#{lib}
      -lcucumber-cpp
      -pthread
    ]
    system ENV.cxx, *cxx_args

    begin
      pid = fork { exec "./test" }
      sleep 1
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test
            Given A given statement
            When A when statement
            Then A then statement

        1 scenario (1 passed)
        3 steps (3 passed)
      EOS
      assert_match expected, shell_output("#{testpath}/bin/cucumber --quiet")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
