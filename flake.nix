{
  description = "styatra.com";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
        ];

        shellHook = ''
          echo "Activating isolated git identity..."

          # Force Git to use the specific SSH key for this session
          # 'IdentitiesOnly=yes' ensures it ignores your default id_rsa
          export GIT_SSH_COMMAND="ssh -i ~/.ssh/styatra -o IdentitiesOnly=yes"

          # Override the user identity for commits
          export GIT_AUTHOR_NAME="styatra"
          export GIT_AUTHOR_EMAIL="hello@styatra.com"
          export GIT_COMMITTER_NAME="styatra"
          export GIT_COMMITTER_EMAIL="hello@styatra.com"

          echo "-> Key: ~/.ssh/styatra"
          echo "-> User: styatra"
          git config user.email
          git config user.name
        '';
      };
    };
}
