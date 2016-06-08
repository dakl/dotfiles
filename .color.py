import socket

black = '30m'
red = '31m'
green = '32m'
yellow = '33m'
blue = '34m'
magenta = '35m'
cyan = '36m'
gray = '37m'

bg_black = '40m'
bg_red = '41m'
bg_green = '42m'
bg_yellow = '43m'
bg_blue = '44m'
bg_magenta = '45m'
bg_cyan = '46m'
bg_gray = '47m'

hosts = {'LM0276MEB':('m', bg_gray),
	 'grond':(gray, bg_red),
	 'milou':(yellow, bg_blue),
	 'anchorage':(black, bg_green),
	 'fairbanks':(black, bg_yellow)
}

hostname = socket.gethostname()

def get_colors():
    for hname in hosts:
	if hostname in hname or hname in hostname:
	    fg = hosts[hname][0]
	    bg = hosts[hname][1]
	    return "\033[{fg}\033[{bg} \u@\h \033[0m".format(fg=fg, bg=bg)

    return "\033[{fg}\033[{bg}\u@\h\033[0m".format(fg='m', bg='')

print get_colors()
