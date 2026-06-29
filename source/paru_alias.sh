# PARU ALIASES & FUNCTIONS

_pa() { paru "-${(C)1}" "${@:2}"; }

_paru_flags=(
  q qq qdt qdtq qe qeq qi qiq qm qmq qq qs qsq
  r rcs rns
  s si ss sy syu
)

for _flag in "${_paru_flags[@]}"; do
  alias "$_flag"="_pa $_flag"
done
unset _flag