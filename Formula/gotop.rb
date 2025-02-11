class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.0.1.tar.gz"
  sha256 "38a34543ed828ed8cedd93049d9634c2e578390543d4068c19f0d0c20aaf7ba0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a61acb05457b28a32d342fc75376785873ec8f9fd73209f079550051851ea54" => :catalina
    sha256 "c758b1001a0de9af2572871c05cd3ec78341e31e2e870a9a147cea493f85baa6" => :mojave
    sha256 "194a6ee2f9ab9922b23a91d8868ac7802f611f238d56d10c79da4c9263a9afa4" => :high_sierra
    sha256 "729149385d029d17a0a713d28c20bb9f4426e24ff3bd63d98379822704bbca1b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    time = `date +%Y%m%dT%H%M%S`.chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X main.Version=#{version} -X main.BuildDate=#{time}", "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    path = OS.mac? ? "Library/Application Support/gotop": ".config/gotop"
    assert_predicate testpath/"#{path}/gotop.conf", :exist?
  end
end
