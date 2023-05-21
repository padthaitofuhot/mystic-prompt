# Mystic Prompt
**A prompt in the style of MysticBBS server software, with graceful fallbacks, implementing [mystic-termlib](https://github.com/padthaitofuhot/mystic-termlib)**

## Features
From top-left to bottom right:
* Indicates whether shelled out of Midnight Commander
* System resource meters for battery, load, and memory+swap
* Simple clock with only the most transient details
* Colorful exit code indicator of previous command success
* New line for git branch and status when in repo
* Exit code of previous command if non-zero
* Standard user @ host; visually distinct when root shell
* $PWD shortened to nearby elements
* Input pip becomes visually distinct when root shell

## Supported OS Stats
| OS       | CPU | Mem     | Bat | 
|----------|-----|---------|-----|
| Linux    | Y   | Y       | Y   |
| FreeBSD  | Y   | Y       |     |
| OpenBSD  | Y   | inexact |     |

## Usage
```shell
mkdir ~/.local/lib
cd ~/.local/lib
git clone https://github.com/padthaitofuhot/mystic-prompt.git
printf "%s\n%s\n\n" "# Mystic Prompt" "source ~/.local/lib/mystic-prompt/mystic.bash" >>~/.bashrc
cd -
```

## Examples
```shell
#    MC─[▆▄▂ˡ]─[▂ᵐ▁ˢ]─────── ·[Sun·30·02:30]·
#    └─ [siv@samadhi] · […/usr/local/sbin]∙ ls -la
#
# ┌─────[▅^ᵇ]─[▆▄▂ˡ]─[▂ᵐ]─── ·[Sun·30·02:30]·
# └ 127 [root@samadhi] · […/usr/local/sbin]# ls -la
#
#    ┌──[▅.ᵇ]─[▆▄▂ˡ]─[▂ᵐ▁ˢ]─ ·[Sun·30·02:30]·
#    │ …-issue-1987 3:0 idx.notup:4 tree.rm:2 untracked:7
#    └─ [siv@samadhi] · […/usr/local/sbin]∙ ls -la
#
# ┌─────[▅?ᵇ]─[▆▄▂ˡ]─[▂ᵐ▁ˢ]─ ·[Sun·30·02:30]·
# │ main 3:0 idx.notup:4 tree.rm:2 untracked:7
# └ 127 [siv@samadhi] · […/usr/local/sbin]∙ ls -la
#
#    ┌──[▆▄▂ˡ]─[▂ᵐ]───────── ·[Sun·30·02:30]·
#    └─ [siv@samadhi] · […/usr/local/sbin]∙ ls -la
#
#    ┌──[▆▄▂ˡ]────────────── ·[Sun·30·02:30]·
#    └─ [siv@samadhi] · […/usr/local/sbin]∙ ls -la
#
# .-----[o^B]-[0OoL]-[oM.S]- -[Sun-30-02:30]-
# : 127 [root@samadhi] - [.../usr/local/sbin]# ls -la
#
# .--[0OoL]----------------- -[Sun-30-02:30]-
# : ...-issue-1987 3:0 idx.notup:4 tree.rm:2 untracked:7
# :. [root@samadhi] - [.../usr/local/sbin]# ls -la
```

## Acknowledgements
Portions of MysticPrompt include software from other authors:
* Git dashboard functions from Bash Color Tools
  * https://github.com/christopher-barry/bash-color-tools
  * Copyright 2007-2012 Christopher Barry <christopher.r.barry@gmail.com>:
  * GPLv3

## References:
* BashHackers Wiki https://wiki.bash-hackers.org/
* GreyCat's Wiki https://mywiki.wooledge.org/BashGuide
  * Specifically: https://mywiki.wooledge.org/BashFAQ/053?highlight=%28PS1%29
