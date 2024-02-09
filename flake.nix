{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    packages =
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
      in {
        "${system}" = rec {
          vello = pkgs.stdenv.mkDerivation rec {
            pname = "vello";
            version = "0.01";
            nativeBuildInputs = with pkgs; [
              rustc
              cargo
              pkg-config
            ];
            buildInputs = with pkgs; [
              llvmPackages.libclang.lib
              stdenv.cc.libc
            ] ++ [
              xorg.libX11
              xorg.libXcursor
              xorg.libXrandr
              xorg.libXi
              xorg.libxcb
              xorg.libXdmcp
              xorg.libXrandr
            ] ++ [
              wayland
              wayland-protocols
            ] ++ [
              libGL
              libGLU
              vulkan-loader
              libxkbcommon
            ];
            LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
            libraryPath = (lib.makeLibraryPath (with pkgs; [
              wayland
              libxkbcommon
              xorg.libX11
              xorg.libXcursor
              xorg.libXrandr
              xorg.libXi
              vulkan-loader
              libGL
              libGLU
            ]));
            shellHook = ''
               export LD_LIBRARY_PATH=/run/opengl-driver/lib/:${libraryPath}
            '';
          };
          default = vello;
        };
      };
  };
}
