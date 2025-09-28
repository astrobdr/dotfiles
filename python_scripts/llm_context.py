# llm_context.py
from pathlib import Path
import argparse, re

def _gather(root, exts=(".py",".txt",".md",".cpp"), include_names=("BUILD","BUILD.bazel"),
            exclude_names=(), exclude_dirs=(), exclude_re=None):
    r = Path(root)
    ex_names = {n.lower() for n in exclude_names}
    inc_names = {n for n in include_names if n}
    exd = tuple(d.strip("/").lower() for d in exclude_dirs)
    rx = re.compile("|".join(f"(?:{p})" for p in exclude_re)) if exclude_re else None
    def skip(p):
        rel = p.relative_to(r).as_posix().lower()
        parts = rel.split("/")[:-1]
        if any(part in exd for part in parts) or any(rel.startswith(d + "/") for d in exd): return True
        return bool(rx.search(rel)) if rx else False
    return sorted(p for p in r.rglob("*")
                  if p.is_file()
                  and (p.suffix.lower() in exts or p.name in inc_names)
                  and p.name.lower() not in ex_names
                  and not skip(p))

def preview_context(root, files):
    total = 0
    for f in files:
        n = sum(1 for _ in open(f, encoding="utf-8", errors="ignore"))
        total += n
        print(f"{Path(f).relative_to(root)} — {n} lines")
    print(f"{len(files)} files, {total} total lines")

def write_context(files, out, root):
    r = Path(root)
    with open(out, "w", encoding="utf-8", errors="ignore") as w:
        for f in files:
            filepath = Path(f).as_posix()
            w.write(f"===== BEGIN {filepath} =====\n")
            w.write(Path(f).read_text(encoding="utf-8", errors="ignore"))
            w.write(f"===== END {filepath} =====\n")
            w.write("\n")
    print(f"Wrote {len(files)} files to {out}")

def main():
    epilog = """Examples:
  # Preview defaults (.py,.txt,.md,.cpp) + Bazel BUILD/BUILD.bazel
  python llm_context.py /path

  # Write inside ROOT (default)
  python llm_context.py /path --write

  # Write to a subdir of ROOT (created if needed)
  python llm_context.py /path --write -O artifacts

  # Write to an absolute directory
  python llm_context.py /path --write -O /tmp/outdir

  # Choose extensions / include extra bare names
  python llm_context.py /proj -e .py,.md -n WORKSPACE,WORKSPACE.bazel

  # Exclude directories and regex paths
  python llm_context.py /proj -X .git,venv,node_modules -x "(^|/)tests(/|$)|\\.ipynb$"

  # Combine everything
  python llm_context.py /proj -w -o my_context.txt -O artifacts -e .py,.md -n BUILD,WORKSPACE -X build,artifacts -x "^docs/old/"
"""
    ap = argparse.ArgumentParser(
        description="Concatenate files into a single context file. Preview by default; use --write to output.",
        formatter_class=argparse.RawTextHelpFormatter,
        epilog=epilog,
    )
    ap.add_argument("root", help="Folder to scan")
    ap.add_argument("-e","--exts", default=".py,.txt,.md,.cpp",
                    help="Comma-separated extensions (e.g. .py,.md or py,md)")
    ap.add_argument("-n","--names", default="BUILD,BUILD.bazel",
                    help="Comma-separated bare filenames to include (no extension), e.g. BUILD,WORKSPACE")
    ap.add_argument("-o","--out", default="context.txt", help="Output file name")
    ap.add_argument("-O","--out-dir", default="",
                    help="Directory to write output (relative to ROOT by default; absolute allowed)")
    ap.add_argument("-w","--write", action="store_true", help="Write the context file (otherwise just preview)")
    ap.add_argument("-X","--exclude-dir", default="", help="Comma-separated dir names/prefixes to skip (e.g. .git,venv)")
    ap.add_argument("-x","--exclude", default="", help="Comma-separated regex patterns matched against relative paths")
    ap.add_argument("--version", action="version", version="llm_context 1.4")
    args = ap.parse_args()

    root = Path(args.root)
    # Resolve output directory: relative -> under ROOT; absolute -> as given
    out_dir = root if not args.out_dir else (Path(args.out_dir) if Path(args.out_dir).is_absolute()
                                             else root / args.out_dir)
    out_path = out_dir / args.out
    # If out_dir is inside ROOT, exclude it from the scan
    exclude_dirs = [d for d in args.exclude_dir.split(",") if d]
    try:
        rel_outdir = out_dir.resolve().relative_to(root.resolve())
        exclude_dirs.append(rel_outdir.as_posix())
    except Exception:
        pass

    exts = tuple(e if e.startswith(".") else f".{e}" for e in args.exts.split(",") if e)
    include_names = tuple(n for n in (s.strip() for s in args.names.split(",")) if n)
    exclude_regexes = [p for p in args.exclude.split(",") if p]
    exclude_names = ("context.txt", args.out)  # never include prior outputs

    files = _gather(root, exts=exts, include_names=include_names,
                    exclude_names=exclude_names, exclude_dirs=exclude_dirs, exclude_re=exclude_regexes)

    if args.write:
        out_dir.mkdir(parents=True, exist_ok=True)
        write_context(files, out_path, root)
    else:
        preview_context(root, files)

if __name__ == "__main__":
    main()
