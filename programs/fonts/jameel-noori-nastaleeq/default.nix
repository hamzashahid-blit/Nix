{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, fetchzip ? pkgs.fetchzip }:

fetchzip {
  name = "jameel-noori-nastaleeq";

  url = "https://urdufonts.net/downloadfiles/zippedfontstyles/j/a/jameel-noori-nastaleeq-regular.zip?st=g7BJMauoq4HrLhvrs8aQjQ&e=1647582270";

  postFetch = ''
    mkdir -p $out/share/fonts/jameel-noori-nastaleeq
    unzip -j $downloadedFile -d $out/share/fonts/jameel-noori-nastaleeq
  '';

  sha256 = "sha256-tbXkrR0sUTuYCIr4uqandOngX2oaBKuS0Yh5Rzw6Kyk=";
}
