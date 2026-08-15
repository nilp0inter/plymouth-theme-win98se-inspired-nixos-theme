{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-win98se-nixos";
  version = "1.0.0";
  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    theme_dir="$out/share/plymouth/themes/win98se-nixos"
    mkdir -p "$theme_dir"
    cp \
      theme/black.png \
      theme/dot.png \
      theme/password.png \
      theme/progress-strip.png \
      theme/screenshot.png \
      theme/win98se-nixos.plymouth \
      theme/win98se-nixos.script \
      "$theme_dir/"

    substituteInPlace "$theme_dir/win98se-nixos.plymouth" \
      --replace-fail '@THEME_DIR@' "$theme_dir"

    runHook postInstall
  '';
}
