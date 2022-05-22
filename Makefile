MSG?=Generate site

BASEDIR=$(CURDIR)
OUTPUTDIR=$(BASEDIR)/public

GITHUB_PAGES_BRANCH=gh-pages

publish: clean build

build:
	hugo
	touch $(OUTPUTDIR)/.nojekyll

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	git worktree prune
	rm -rf $(BASEDIR)/.git/worktrees/public/
	echo "Checking out gh-pages branch into output directory"
	git worktree add -B gh-pages $(OUTPUTDIR) origin/$(GITHUB_PAGES_BRANCH)
	echo "Removing existing files"
	rm -rf $(OUTPUTDIR)/*

github: publish
	cd $(OUTPUTDIR) && git add --all && git commit -m "$(MSG)"
	git push origin $(GITHUB_PAGES_BRANCH)

.PHONY: publish clean github
