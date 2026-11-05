#!/usr/bin/env bash
# check-playbook.sh — the playbook's own gate. Every check prints PASS/FAIL; exit non-zero on any FAIL.
#   links      every relative markdown link resolves
#   skills     SKILL.md frontmatter `name:` equals its directory, and has a description
#   agents     agent frontmatter `name:` equals the file stem (personas included), and has description + model
#   scripts    bash -n on every .sh; the machine guard's self-test passes
#   private    no private IPs, secrets-looking strings, or machine-local paths in shareable files
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
pass() { printf '  PASS  %s\n' "$*"; }
bad()  { printf '  FAIL  %s\n' "$*"; fail=1; }

echo "links"
# Python does the parsing: skip fenced code blocks, inline code spans and HTML comments (examples live there).
if out="$(python3 -I - <<'PY'
import os, re, sys
n = bad = 0
for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in dirs if d != '.git']
    for f in files:
        if not f.endswith('.md'):
            continue
        path = os.path.join(root, f)
        text = open(path, encoding='utf-8').read()
        text = re.sub(r'```.*?```', '', text, flags=re.S)
        text = re.sub(r'<!--.*?-->', '', text, flags=re.S)
        text = re.sub(r'`[^`\n]*`', '', text)
        for link in re.findall(r'\]\(([^)\s]+)\)', text):
            if re.match(r'^(https?:|mailto:|#)', link):
                continue
            target = link.split('#')[0]
            n += 1
            if not os.path.exists(os.path.join(root, target)):
                print(f"  FAIL  {path} -> {link}"); bad += 1
print(f"__N={n} __BAD={bad}")
sys.exit(1 if bad else 0)
PY
)"; then pass "$(echo "$out" | sed -n 's/.*__N=\([0-9]*\).*/\1/p') relative links resolve"
else echo "$out" | grep -v '^__N='; fail=1; fi

echo "skills"
for f in user-level/skills/*/SKILL.md; do
  d="$(basename "$(dirname "$f")")"
  name="$(sed -n 's/^name: *//p' "$f" | head -1)"
  [[ "$name" == "$d" ]] || bad "$f: name '$name' != dir '$d'"
  grep -q '^description: ' "$f" || bad "$f: no description"
  # YAML: an unquoted " #" starts a comment and silently truncates the description (it cut "fix #N" once).
  grep -qE '^description: [^"'"'"'].* #' "$f" && bad "$f: ' #' in an unquoted description truncates it"
done
[[ $fail -eq 0 ]] && pass "$(ls user-level/skills | wc -l | tr -d ' ') skills: names match dirs, descriptions present"

echo "agents"
af=0
for f in user-level/agents/*.md template/.claude/agents/*.md; do
  stem="$(basename "$f" .md)"
  name="$(sed -n 's/^name: *//p' "$f" | head -1)"
  [[ "$name" == "$stem" ]] || { bad "$f: name '$name' != '$stem'"; af=1; }
  grep -q '^description: ' "$f" || { bad "$f: no description"; af=1; }
  grep -q '^model: ' "$f" || { bad "$f: no model"; af=1; }
done
(( af == 0 )) && pass "agents: names match files; description + model present"

echo "scripts"
sf=0
while IFS= read -r s; do bash -n "$s" || { bad "syntax: $s"; sf=1; }; done < <(find . -name '*.sh' -not -path './.git/*')
(( sf == 0 )) && pass "bash -n on every script"
if python3 -I template/.claude/hooks/machine-guard.py --self-test >/dev/null; then pass "machine-guard self-test"
else bad "machine-guard self-test"; fi

echo "private"
pat='192\.168\.|10\.[0-9]+\.[0-9]+\.[0-9]+|AuthKey_|BEGIN (RSA|OPENSSH|PGP) PRIVATE|sk-ant-|ghp_[A-Za-z0-9]{20}|/Users/[a-z]+/|smb://'
hits="$(grep -rnE "$pat" --include='*.md' --include='*.sh' --include='*.py' --include='*.json' --include='*.example' . \
        | grep -v '^./.git/' | grep -v 'scripts/check-playbook.sh' || true)"
if [[ -z "$hits" ]]; then pass "no private IPs, keys or machine paths"; else bad "possible private material:"; echo "$hits" | sed 's/^/        /'; fi

echo
(( fail == 0 )) && echo "PLAYBOOK CHECK: PASS" || echo "PLAYBOOK CHECK: FAIL"
exit "$fail"
