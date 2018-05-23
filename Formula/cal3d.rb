class Cal3d < Formula
  desc "Skeletal 3D character animation library written in C++"
  homepage "http://cal3d.sourceforge.net/docs/api/html/cal3dfaq.html"
  url 'https://github.com/hlrs-vis/cal3d.git', :using => :git, :revision => '8cbf44f8c20a191b67063cb943420ec55e7125b8'
  version '2018.5'
  head "git://github.com/hlrs-vis/cal3d.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    Dir.chdir('cal3d')
    system "autoreconf", "-i"
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "cal3d_converter", "--help"
  end
end
