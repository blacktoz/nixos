{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python3
    gtk3
    gobject-introspection
    vte
    keybinder3
    libwnck
    libnotify

    (python3.withPackages (ps: with ps; [
      pygobject3
      libsass
    ]))
  ];


  shellHook = ''
    echo ""
    echo "Dev shell for `pwd` -> 🐍"
    echo "   • Language: Python GTK3"
    echo "   • Version: $(python3 --version)"
    echo "   • Usage: python3 -m termm.termm"
    echo ""
  '';
}
