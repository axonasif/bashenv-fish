#!/usr/bin/fish

if status is-full-job-control;
  set job_control_type full;
else if status is-interactive-job-control;
  set job_control_type interactive;
end

status job-control none;

# TODO: Maybe we could also create a `declare` function on fish to avoid replacing it from bash
bash -lic 'declare -px' \
  | string replace --regex '^declare -x' export \
  | string replace --regex '^export (SHLVL|PWD|SHELL|PS1|OLDPWD|LS_COLORS|_)=' ': export _=' \
  | source

switch "$job_control_type";
  case "interactive";
    status job-control "$job_control_type";
  case "full";
    status job-control "$job_control_type";
end

## Old method:
# set -l var_split '<<;@@;>>'
# set -l value_split '<<;##;>>'
# set blacklist_regex "^(SHLVL|PWD|SHELL|PS1|OLDPWD|LS_COLORS|BASH_FUNC.*|_)$var_split"
# for value in (bash $bash_args "compgen -e | while read -r var; do \echo -n \"\${var}$var_split\${!var}$value_split\"; done" | string split -n $value_split)
#     if string match --quiet --regex --invert $blacklist_regex $value
#         set -gx (string split $var_split $value) 2>/dev/null || true
#     end
# end
