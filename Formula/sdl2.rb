class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.12.tar.gz"
  sha256 "349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863"
  revision 1

  bottle do
    cellar :any
    sha256 "4dcd635465d16372ca7a7bb2b94221aa21de02f681a22e9239d095b66fb00c63" => :catalina
    sha256 "8733b127dd4ba6179e6ad9e6336418df9dbad8eb13f05597c05e6916f2ff0543" => :mojave
    sha256 "b71346aebd499ed30f6de2f58a333c50575bc3bf73fbba6dcaef5a04c58282c5" => :high_sierra
    sha256 "f8b79add67cd5cba1c73f7afa7df16291c934d6ebafa8ad7d3bee6a2512aefac" => :x86_64_linux
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "linuxbrew/xorg/libice"
    depends_on "linuxbrew/xorg/libxcursor"
    depends_on "linuxbrew/xorg/libxscrnsaver"
    depends_on "linuxbrew/xorg/libxxf86vm"
    depends_on "linuxbrew/xorg/xinput"
    depends_on "pulseaudio"
  end

  # Fix library extension in CMake config file.
  # https://bugzilla.libsdl.org/show_bug.cgi?id=5039
  patch do
    url "https://bugzilla.libsdl.org/attachment.cgi?id=4263"
    sha256 "07ea066e805f82d85e6472e767ba75d265cb262053901ac9a9e22c5f8ff187a5"
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = if OS.mac?
      %W[--prefix=#{prefix} --without-x]
    else
      %W[--prefix=#{prefix} --with-x]
    end

    unless OS.mac?
      args += %w[
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
      ]
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
