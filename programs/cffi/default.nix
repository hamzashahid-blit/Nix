args @ { fetchurl, fetchpatch, ... }:
rec {
  baseName = "cffi";
  version = "cffi_0.24.1";

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = "The Common Foreign Function Interface";

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz";
    sha256 = "1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/cffi/cffi/commit/93da14314a33c907721f5279137cae0995364d43.patch";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  })];

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
