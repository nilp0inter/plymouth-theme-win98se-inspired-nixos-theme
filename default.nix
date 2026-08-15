{
  lib,
  stdenvNoCC,
  resvg,
  liberation_ttf,
  writeText,
  boot_label ? lib.trivial.release,
}:

let
  label_svg = writeText "win98se-nixos-boot.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg"
         width="2368"
         height="1776"
         viewBox="0 0 2368 1776">
      <defs>
        <filter id="antialias"
                x="-5%"
                y="-5%"
                width="110%"
                height="110%"
                color-interpolation-filters="sRGB">
          <feGaussianBlur stdDeviation="0.45"/>
        </filter>
      </defs>
      <image href="${./theme/boot-base.png}" width="2368" height="1776"/>
      <text x="1808"
            y="1610"
            fill="#000000"
            font-family="Liberation Sans"
            font-size="144"
            text-anchor="end"
            text-rendering="geometricPrecision"
            filter="url(#antialias)">${lib.escapeXML boot_label}</text>
    </svg>
  '';
in
stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-win98se-nixos";
  version = "1.0.0";
  src = ./.;

  nativeBuildInputs = [ resvg ];
  bootLabel = boot_label;

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
      theme/win98se-nixos.plymouth \
      theme/win98se-nixos.script \
      "$theme_dir/"
    if [ -n "$bootLabel" ]; then
      resvg \
        --skip-system-fonts \
        --use-font-file \
        "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf" \
        "${label_svg}" \
        "$theme_dir/screenshot.png"
    else
      cp theme/boot-base.png "$theme_dir/screenshot.png"
    fi

    substituteInPlace "$theme_dir/win98se-nixos.plymouth" \
      --replace-fail '@THEME_DIR@' "$theme_dir"

    runHook postInstall
  '';
}
