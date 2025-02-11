class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.6.tar.gz"
  sha256 "b4d9d965080f795d98894c6fb615d8469ebdec8fc17dec503b5e546445bfaa03"

  bottle do
    cellar :any
    sha256 "06d6f12a038c1b05c47d4d70c432492ad68462cae2fd1a1c6ae72e3e277908b4" => :catalina
    sha256 "db027f5b570d3aa43869b5a638c36099f7275561138605dd901c58b5cdd94bea" => :mojave
    sha256 "f2ad5244fcb61cc657133ee4d6c81975f6a9b85da0b3f58e129ff7bcd557a475" => :high_sierra
    sha256 "0f616dbe6b0781313220a9b9e8cae57cc3d7f7e45572f03b7579de5d9f971254" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   *("-pthread" unless OS.mac?),
                   *("-I#{include}" unless OS.mac?),
                   *("-Wl,-rpath=#{lib}" unless OS.mac?),
                   "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
