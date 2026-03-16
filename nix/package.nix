{ pkgs }:
let
  packageJson = builtins.fromJSON (builtins.readFile ../package.json);
in
pkgs.buildNpmPackage rec {
  pname = "git-mcp-server";
  version = packageJson.version;

  src = pkgs.lib.cleanSource ../.;
  npmDepsHash = "sha256-LVSfqLEBlM01s5lClcxsMZaE/Xa4X5kCfHY+0AF090M=";

  nativeBuildInputs = [ pkgs.bun pkgs.makeWrapper ];
  npmPackFlags = [ "--ignore-scripts" ];

  postInstall = ''
    wrapProgram "$out/bin/git-mcp-server" \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.git ]}
  '';

  meta = with pkgs.lib; {
    description = packageJson.description;
    homepage = packageJson.homepage;
    license = licenses.asl20;
    mainProgram = "git-mcp-server";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
