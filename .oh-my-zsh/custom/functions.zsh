# Add a new cheat sheet entry
cheat-add() {
  if [[ $# -ne 4 ]]; then
    echo "Usage: cheat-add <tool> <category> <keys> <desc>"
    return 1
  fi
  local file="$HOME/.config/cheat/cheat.sh"
  python3 -c "
lines = open('$file').readlines()
entry = '  \"$1|$2|$3|$4\"\n'
for i, line in enumerate(lines):
    if line.rstrip() == ')':
        lines.insert(i, entry)
        break
open('$file', 'w').writelines(lines)
"
  echo "Added: $1 › $2 › $3 › $4"
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
