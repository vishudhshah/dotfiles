# Add a new cheat sheet entry
cheat-add() {
  if [[ $# -ne 4 ]]; then
    echo "Usage: cheat-add <tool> <category> <keys> <desc>"
    return 1
  fi
  local file="$HOME/.config/cheat/cheat.sh"
  python3 - "$file" "$@" <<'PY'
import sys

filename, *fields = sys.argv[1:]
if any(any(char in field for char in "|\r\n") for field in fields):
    sys.exit("cheat-add: fields cannot contain pipes or newlines")

# Double-quoted Zsh strings must keep substitutions and quotes literal.
value = "|".join(fields)
for char in ('\\', '"', '$', '`'):
    value = value.replace(char, '\\' + char)
entry = '  "' + value + '"\n'

try:
    with open(filename, "r+", encoding="utf-8", newline="") as sheet:
        lines = sheet.readlines()
        starts = [i for i, line in enumerate(lines) if line.strip() == "COMMANDS=("]
        if len(starts) != 1:
            sys.exit("cheat-add: expected one COMMANDS array")
        end = next((i for i in range(starts[0] + 1, len(lines))
                    if lines[i].strip() == ")"), None)
        if end is None:
            sys.exit("cheat-add: COMMANDS array has no closing parenthesis")
        lines.insert(end, entry)
        sheet.seek(0)
        sheet.writelines(lines)
        sheet.truncate()
except OSError as exc:
    sys.exit(f"cheat-add: {exc}")
PY
  local result=$?
  (( result == 0 )) || return "$result"
  printf 'Added: %s › %s › %s › %s\n' "$@"
}

# yazi shell wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Git add, commit and push in one command
gacp() {
  ga . && git commit -m "$*" && gp
}

# Transcribe video to SRT subtitles using whisper.cpp
whisper() {
  ffmpeg -i "$1" -ar 16000 -ac 1 -c:a pcm_s16le "${1%.*}.wav" 2>/dev/null && \
  whisper-cli \
    -f "${1%.*}.wav" \
    -m ~/.config/whisper-models/ggml-large-v3-turbo.bin \
    -osrt \
    --no-prints \
    -of "${1%.*}" 2>/dev/null && \
  rm "${1%.*}.wav"
}

# Update custom zsh plugins
update-zsh-plugins() {
  for d in ~/.oh-my-zsh/custom/plugins/*/; do
    [[ -d "$d/.git" ]] || continue
    echo "Updating ${d:t}..."
    git -C "$d" pull
  done
}
