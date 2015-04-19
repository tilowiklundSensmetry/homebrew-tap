require 'formula'

class Openinventor < Formula
  homepage 'http://oss.sgi.com/projects/inventor/'
  url 'git://github.com/aumuell/open-inventor.git'
  version '2.1.5-10'
  sha1 ''

  depends_on :x11
  depends_on "lesstif"
  depends_on "jpeg"
  depends_on "giflib"

  def install
    # Make ivman find the libraries it needs
    ENV['DYLD_LIBRARY_PATH'] = "#{buildpath}/lib"

    system "make",
        "IVPREFIX=#{prefix}",
        "BUILDMAN=1",
        "install"
  end

  def test
    system "ivfix #{prefix}/share/inventor/data/models/moon.iv"
  end
end
