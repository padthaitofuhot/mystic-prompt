source src/header.bash
source mystic-config.bash
for srcfile in  terminal.bash \
								filters.bash \
								utilities.bash \
								frame-parts.bash \
								load-graphs-widget.bash \
								clock-widget.bash \
								git-widget.bash \
								userhost-widget.bash \
								pwd-widget.bash \
								input-pip-widget.bash \
								core.bash; do
	source "src/${srcfile}"
done
