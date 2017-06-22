require 'formula'

class Covise < Formula
  homepage 'https://www.hlrs.de/covise/'
  desc 'Visualization environment for scientific and engineering data'
  url 'https://github.com/hlrs-vis/covise.git', :using => :git, :revision => '4d7b0304bd8a62bb1a1d30dbab29f842047b1d7b'
  version '2017.6'
  head 'https://github.com/hlrs-vis/covise.git'

  option "with-cuda", "Build with CUDA support"
  option "with-jpeg", "Build against libjpeg instead of libjpeg-turbo"
  option "with-x11", "Build against X11 and Open Motif"
  option "without-cover", "Build without OpenCOVER VR renderer"

  depends_on "cmake" => :build
  depends_on "swig" => :build

  depends_on "xerces-c"
  depends_on "glew"
  depends_on "jpeg" => :optional
  depends_on "jpeg-turbo" if build.without? "jpeg"
  depends_on "giflib"
  #depends_on "libpng12"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "freetype"
  depends_on "boost"
  depends_on "python3"
  depends_on "qt"
  depends_on :x11 => :optional
  depends_on "homebrew/x11/openmotif" if build.with? "x11"
  depends_on "hlrs-vis/tap/openinventor" if build.with? "x11"
  depends_on "assimp" => :optional
  depends_on "cgns" => :optional
  depends_on "snappy" => :optional
  depends_on "Caskroom/cask/cuda" if build.with? "cuda"

  depends_on "openscenegraph" if build.with? "cover"

  depends_on :fortran  => :optional
  #conflicts_with "fortran", :because => "linking with Fortran libraries fails without explicit Fortran dependency, specify --with-fortran" if build.without? "fortran"

  depends_on "vtk" => :optional
  conflicts_with "vtk", :because => "including VTK headers fails without explicit VTK dependency, specify --with-vtk" if build.without? "vtk"

  option "with-gdcm", "Build with GDCM for DICOM reading"
  depends_on "homebrew/science/gdcm" if build.with? "gdcm"
  conflicts_with "gdcm", :because => "including GDCM headers fails without explicit GDCM dependency, specify --with-gdcm" if build.without? "gdcm"

  depends_on "sdl" => :optional
  conflicts_with "sdl", :because => "including SDL header fails without explicit SDL dependency, specify --with-sdl" if build.without? "sdl"

  def install
    ENV["COVISEDIR"] = buildpath
    ENV["COVISEDESTDIR"] = buildpath
    if MacOS.version >= :el_capitan
        ENV["ARCHSUFFIX"] = "macosopt"
    else
        ENV["ARCHSUFFIX"] = "libc++opt"
    end

    cmake_args = std_cmake_args
    cmake_args << "-DCOVISE_USE_VISIONARAY=OFF"
    cmake_args << "-DCOVISE_USE_FORTRAN:BOOL=ON" if build.with? "fortran"
    cmake_args << "-DCOVISE_USE_FORTRAN:BOOL=OFF" if build.without? "fortran"
    cmake_args << "-DCOVISE_USE_CUDA:BOOL=ON" if build.with? "cuda"
    cmake_args << "-DCOVISE_USE_CUDA:BOOL=OFF" if build.without? "cuda"
    cmake_args << "-DCOVISE_USE_X11:BOOL=ON" if build.with? "x11"
    cmake_args << "-DCOVISE_USE_X11:BOOL=OFF" if build.without? "x11"

    #cmake_args << "-DCOVISE_USE_VIRVO=OFF"
    #cmake_args << "-DCOVISE_BUILD_MODULES=OFF"

    mkdir "build.covise" do
        system "cmake", "..", *cmake_args
        system "make install"
    end

    if build.with? "cover"
        mkdir "build.cover" do
            system "cmake", "../src/OpenCOVER", *cmake_args
            system "make install"
        end
    end
  end

  test do
  end
end
