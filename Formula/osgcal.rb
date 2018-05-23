class Osgcal < Formula
  desc "Cal3D adapter for OpenSceneGraph, imported from https://sourceforge.net/p/osgcal/code"
  homepage "http://osgcal.sourceforge.net"
  url 'https://github.com/hlrs-vis/osgcal.git', :using => :git, :revision => 'fbefbd54bb4ec822bb192073f93e904b2645a162'
  version '2018.5'
  head "git://github.com/hlrs-vis/osgcal.git"

  depends_on "cmake" => :build
  depends_on "open-scene-graph"
  depends_on "cal3d"

  bottle do
    root_url "https://fs.hlrs.de/projects/covise/support/download/homebrew"
    cellar :any
    sha256 "3f70624cb50d857d820308b485f5a9a564fa752211bc3f8fba774d2cc32c29c6" => :high_sierra
  end

  def install
    Dir.chdir('osgCal')
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "osgCalViewer", "-h"
  end
end
