require 'formula'

class Openinventor < Formula
  homepage 'http://oss.sgi.com/projects/inventor/'
  url 'git://gitorious.org/inventor/inventor.git'
  version '2.1.5-10'
  sha1 ''

  depends_on :x11
  depends_on "lesstif"

  def install
    system "make",
        "IVPREFIX=#{prefix}"
    system "make",
        "IVPREFIX=#{prefix}",
        "install"
  end

  def test
    system "ivfix #{prefix}/share/inventor/data/models/moon.iv"
  end
end
