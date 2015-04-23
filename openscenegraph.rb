require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openscenegraph < Formula
  homepage 'http://www.openscenegraph.org'
  url 'http://www.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.2.1.zip'
  version '3.2.1'
  sha1 '5c666531f7d487075fd692d89f1e05036306192a'

  depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          #"--prefix=#{prefix}"
    system "cmake", \
        "-DOSG_WINDOWING_SYSTEM:STRING=Cocoa", \
        "-DFFMPEG_LIBAVCODEC_INCLUDE_DIRS=OFF", \
        ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test OpenSceneGraph`.
    system "false"
  end
end
