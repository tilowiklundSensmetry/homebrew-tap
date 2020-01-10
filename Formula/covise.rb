require 'formula'

class Covise < Formula
  homepage 'https://www.hlrs.de/covise/'
  desc 'Visualization environment for scientific and engineering data'
  url 'https://github.com/hlrs-vis/covise.git', :using => :git, :revision => 'bca9233ef05e83085acc8dcf25dfa39fd5863851'
  version '2020.1'
  head 'https://github.com/hlrs-vis/covise.git', :using => :git

  option "with-cuda", "Build with CUDA support"
  option "with-jpeg", "Build against libjpeg instead of libjpeg-turbo"
  option "with-x11", "Build against X11 and Open Motif"
  option "with-fortran", "Build modules requiring Fortran"
  option "with-mpi", "Build OpenCOVER with MPI support"
  option "without-assimp", "Build without support for reading 3D models with Assimp"
  option "without-vtk", "Build without support for VTK data"
  option "without-hdf5", "Build without support for HDF5 based file formats"
  option "without-mpi", "Build without support for MPI in OpenCOVER"

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
  depends_on "gdcm"
  depends_on "teem" => :recommended
  depends_on "hdf5" => :recommended
  depends_on :x11 => :optional
  depends_on "homebrew/openmotif" if build.with? "x11"
  depends_on "hlrs-vis/tap/openinventor" if build.with? "x11"
  depends_on "assimp" => :recommended
  #depends_on "cgns" => :optional
  depends_on "snappy" => :optional
  depends_on "Caskroom/cask/cuda" if build.with? "cuda"
  depends_on "proj" => :recommended
  depends_on "gdal" => :recommended
  depends_on "libarchive"

  # OpenCOVER
  depends_on "open-scene-graph"
  depends_on "hidapi"
  depends_on "eigen"
  depends_on "hlrs-vis/tap/osgcal"
  depends_on "hlrs-vis/tap/opencrg"
  #depends_on "mpich" => :optional
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "mpich" if build.with? "mpich"


  depends_on :gcc  if build.with? "fortran"
  #conflicts_with "fortran", :because => "linking with Fortran libraries fails without explicit Fortran dependency, specify --with-fortran" if build.without? "fortran"

  depends_on "vtk" => :recommended
  conflicts_with "vtk", :because => "including VTK headers fails without explicit VTK dependency, specify --with-vtk" if build.without? "vtk"

  #option "with-gdcm", "Build with GDCM for DICOM reading"
  #depends_on "homebrew/gdcm" if build.with? "gdcm"
  #conflicts_with "gdcm", :because => "including GDCM headers fails without explicit GDCM dependency, specify --with-gdcm" if build.without? "gdcm"

  depends_on "sdl" # => :optional
  #conflicts_with "sdl", :because => "including SDL header fails without explicit SDL dependency, specify --with-sdl" if build.without? "sdl"

  def install
    ENV["COVISEDIR"] = buildpath
    ENV["COVISEDESTDIR"] = buildpath
    ENV["EXTERNLIBS"] = ""
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
    cmake_args << "-DCOVISE_USE_MPI:BOOL=OFF" if build.without? "mpi"
    cmake_args << "-DCOVISE_USE_MPI:BOOL=ON" if build.with? "mpi"

    #cmake_args << "-DCOVISE_USE_VIRVO=OFF"
    #cmake_args << "-DCOVISE_BUILD_MODULES=OFF"

    mkdir "build.covise" do
        system "cmake", "..", *cmake_args
        system "make install"
    end
  end

  test do
  end
end
