class Opencrg < Formula
  desc "Creation and evaluation of road surfaces"
  homepage "http://www.opencrg.org/"
  url "http://www.vires.com/opencrg/tools/OpenCRG.1.1.2.zip"
  version "1.1.2"
  sha256 "3ff63ced6190dc22278cd74592e165aca9acf93153c51c93c569744d7714c97b"
  # depends_on "cmake" => :build

  def install
    Dir.chdir('c-api/baselib')
    ENV.deparallelize # if your formula fails when building in parallel
    system "make", "COMP=clang", "CFLGS=-O2 -g -fPIC -Iinc"
    system "install", "-d", "#{prefix}/include", "#{prefix}/lib"
    system "install", "inc/crgBaseLibPrivate.h", "inc/crgBaseLib.h", "#{prefix}/include"
    system "install", "lib/libOpenCRG.#{version}.a", "lib/libOpenCRG.a", "#{prefix}/lib"
  end

  test do
    system "test", "-f", "#{prefix}/lib/libOpenCRG.a"
  end
end
