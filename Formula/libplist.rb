class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/archive/2.2.0.tar.gz"
  sha256 "7e654bdd5d8b96f03240227ed09057377f06ebad08e1c37d0cfa2abe6ba0cee2"

  bottle do
    cellar :any
    sha256 "20faf60d286c8ceed790a9b6e34245acf7bafacc7fcbcb390d6b62e194b323e6" => :catalina
    sha256 "768453f8710ec1c3e074ad0ebc7723da88c2b8575e5de6962ca6f1d4a85cb61d" => :mojave
    sha256 "02291f2f28099a73de8fa37b49962fe575a434be63af356cceff9200c6d73f37" => :high_sierra
    sha256 "f9499d34d2b486a2a2ec069da288f8069603f29647ad7e7429f0d78ce24bdaaa" => :x86_64_linux
  end

  head do
    url "https://git.sukimashita.com/libplist.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-cython
    ]

    system "./autogen.sh", *args
    system "make"
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end

  test do
    (testpath/"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>test</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/echo</string>
        </array>
      </dict>
      </plist>
    EOS
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath/"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end
