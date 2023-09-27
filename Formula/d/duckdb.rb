class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.0",
      revision: "0d84ccf478578278b2d1168675b8b93c60f78a5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2c09d640710877938e16c4c13c04f119f92c01a14905c6b4f6145ceb6a73ab4"
    sha256 cellar: :any,                 arm64_ventura:  "980d9dbc3f4dd56827d400a48e83384fa1781e5da94885d13b5e7d835a495b54"
    sha256 cellar: :any,                 arm64_monterey: "14a56443f58e9959845e34b00ed216c962a94ca9e4b2820696b159bff2e30563"
    sha256 cellar: :any,                 sonoma:         "5a7f83db6a1887627db3b83469e073e2f81d8dc45d3d74de4fe3023c4b61219f"
    sha256 cellar: :any,                 ventura:        "fee724ece936d7c07cb1324c78235e7c75975304ee5b3d65421e6e6c4fb7981d"
    sha256 cellar: :any,                 monterey:       "ab9ff4d2c4d3614d41634b56d99cba061f4673aab473b0e4266d2d25246732a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d890f7a8a34896ff7f52e9f785f781ffa9a36503af71881118ba97dfb7973811"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DCMAKE_LTO=thin", "-DENABLE_EXTENSION_AUTOLOADING=1",
             "-DENABLE_EXTENSION_AUTOINSTALL=1"
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
