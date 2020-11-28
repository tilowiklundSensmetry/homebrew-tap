class Openinventor < Formula
  homepage 'http://oss.sgi.com/projects/inventor/'
  url 'https://github.com/aumuell/open-inventor.git', :using => :git
  version '2.1.5-10'
  sha256 ''

  depends_on "cmake" => :build

  depends_on "openmotif"
  depends_on "libxi"
  depends_on "mesa"
  depends_on "mesa-glu"
  depends_on "jpeg"

  def install
    mkdir "brew-build" do
      system "cmake", "..", *std_cmake_args,
        "-DCMAKE_MACOSX_RPATH=FALSE"
      system "make", "install"
    end
  end

  test do
    system "ivcat #{share}/inventor/data/models/moon.iv"
  end
end
