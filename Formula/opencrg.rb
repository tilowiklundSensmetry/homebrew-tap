class Opencrg < Formula
  desc "Creation and evaluation of road surfaces"
  homepage "http://www.opencrg.org/"
  url "http://www.opencrg.org/tools/OpenCRG.1.1.2.zip"
  version "1.1.2"
  sha256 "3ff63ced6190dc22278cd74592e165aca9acf93153c51c93c569744d7714c97b"

  def install
    Dir.chdir("c-api/baselib")
    ENV.deparallelize
    system "make", "COMP=clang", "CFLGS=-O2 -g -fPIC -Iinc"
    include.install "inc/crgBaseLibPrivate.h", "inc/crgBaseLib.h"
    lib.install "lib/libOpenCRG.#{version}.a", "lib/libOpenCRG.a"
  end

  test do
    system "test", "-f", "#{lib}/libOpenCRG.a"
  end
end
