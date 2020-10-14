class Opencrg < Formula
  desc "Creation and evaluation of road surfaces"
  homepage "http://www.opencrg.org/"
  url "https://www.asam.net/index.php?eID=dumpFile&t=f&f=3797&token=d989315866f73b528757d971b60f4c81bc2526f9"
  version "1.1.2"
  sha256 "598b8d08e5ee35ec972dac35be871a378ac2dde9ac96dbdd063e9cdde9344bda"

  def install
    Dir.chdir("OpenCRG.#{version}/c-api/baselib")
    ENV.deparallelize
    system "make", "COMP=clang", "CFLGS=-O2 -g -fPIC -Iinc"
    include.install "inc/crgBaseLibPrivate.h", "inc/crgBaseLib.h"
    lib.install "lib/libOpenCRG.#{version}.a", "lib/libOpenCRG.a"
  end

  test do
    system "test", "-f", "#{lib}/libOpenCRG.a"
  end
end
