class Vistle < Formula
  homepage "https://vistle.io"
  desc "Parallel visualization system"
  url "https://github.com/vistle/vistle.git", :using => :git, :revision => "6a80121f69181e1b147aedb6e2619ef3e3c68042"
  version "2020.9"
  head "https://github.com/vistle/vistle.git", :using => :git

  option "without-cover", "Build without VR renderer"
  option "without-vtk", "Build without support for VTK data"
  option "with-mpich", "Build with MPICH instead of Open MPI"

  depends_on "cmake" => :build

  depends_on "glew"
  depends_on "coreutils" # for grealpath
  depends_on "jpeg" => :optional
  depends_on "jpeg-turbo" if build.without? "jpeg"
  depends_on "boost"
  depends_on "python3"
  depends_on "qt"
  depends_on "assimp" => :recommended
  depends_on "hdf5" => :optional
  depends_on "snappy" => :optional
  depends_on "libarchive"
  depends_on "lz4"
  depends_on "zstd"
  depends_on "open-scene-graph" => :optional
  depends_on "embree"
  depends_on "ispc"
  depends_on "covise" if build.with? "cover"

  depends_on "mpich" if build.with? "mpich"
  depends_on "open-mpi" if build.without? "mpich"

  depends_on "vtk" => :recommended
  conflicts_with "vtk", :because => "including VTK headers fails without explicit VTK dependency, specify --with-vtk" if build.without? "vtk"

  def install
    ENV["COVISEDIR"] = "#{HOMEBREW_PREFIX}/opt/covise"
    ENV["COVISEDESTDIR"] = buildpath
    ENV["EXTERNLIBS"] = ""
    if MacOS.version >= :el_capitan
      ENV["ARCHSUFFIX"] = "macosopt"
    else
      ENV["ARCHSUFFIX"] = "libc++opt"
    end

    cmake_args = std_cmake_args

    mkdir "build.vistle" do
      system "cmake", "..", *cmake_args
      system "make install"
    end
  end

  test do
    system "vistle", "-h"
  end
end
