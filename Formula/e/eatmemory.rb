class Eatmemory < Formula
  desc "Simple program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "568622f6aef9e20e7d5c5bb66ab7ce74bec458415b8135921fe6d2425450b374"
  license "MIT"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # test version match
    out = shell_output "#{bin}/eatmemory -?"
    version_escaped = version.to_s.gsub(/\./, '\.')
    assert_match %r{^eatmemory #{version_escaped} - https://github.com/julman99/eatmemory\n.*}, out

    # test for expected output
    out = shell_output "#{bin}/eatmemory -t 0 10M"
    assert_match( \
      /^|\nEating 10485760 bytes in chunks of 1024\.\.\.\nDone, sleeping for 0 seconds before exiting\.\.\.\n/, out
    )

    # test for memory correctly consumed
    memory_list = [10, 20, 100]
    memory_list.each do |memory_mb|
      memory_column = 5
      memory_column = 4 if OS.linux?

      fork do
        shell_output "#{prefix}/bin/eatmemory -t 60 #{memory_mb}M 2>&1"
      end
      sleep 5 # sleep to allow the forked process to initialize and eat the memory

      out = shell_output \
        "COLUMNS=500 ps aux | grep -v grep | grep -v 'sh -c' | grep '#{prefix}/bin/eatmemory -t 60 #{memory_mb}'"

      columns = out.split
      used_bytes = columns[memory_column].to_i
      assert_operator used_bytes, ">=", memory_mb * 1024
      assert_operator used_bytes, "<", memory_mb * 2 * 1024
    end
  end
end
