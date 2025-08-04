build:
	rm -rf book theme/*
	mdbook build
	if [ -f .git2rss -a -x git2rss ] ; then ./git2rss > book/commits.xml ; fi

serve:
	rm -rf book theme/*
	mdbook serve --open --hostname 127.0.0.1 --port 3303

serve-all:
	rm -rf book theme/*
	mdbook serve --open --hostname 0.0.0.0 --port 3303

###############################################################################
#
# Change the 'push' target to reference the specific target(s) you want the
# site to be published to. Examples:
#
#   push: rsync
#   push: gh-pages

push:

########################################
# Push the rendered site to https://foks-book.jms1.info/
# - until the "real" book has its own URL
# - when I'm working on content that I'm not ready to "publish" for real yet,
#   but want other people to be able to see

jms1: build
	rsync -avz --delete book/ /keybase/team/jms1team.sites/foks-book/

########################################
# IF you're going to publish the generated book to a web server, and you're
# able to use 'rsync' to upload the files ...
#
# - Change the 'push:' line to include the 'rsync' target
# - Edit the rsync command below as needed.
# - For Keybase Sites, the target will be a path under '/keybase/'. Seee
#   https://jms1.keybase.pub/kbsites/ for more specific examples.

rsync: build
	rsync -avz --delete book/ host.domain.xyz:/var/www/html/newbook/
