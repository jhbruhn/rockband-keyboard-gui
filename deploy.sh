#!/bin/sh
set -ev

if [ ${TRAVIS_JOB_NUMBER##*.} -eq 1 ] && [ "$TRAVIS_BRANCH" = "master" ]; then
  mkdir out/
  cp dist/*.zip out/
  cp dist/*.exe out/
  cp dist/package.json out/
  sudo pip install ghp-import
	ghp-import -n out/ -m "Deploy ${TRAVIS_BUILD_NUMBER}."
	git push -fq https://$GIT_TOKEN@github.com/$TRAVIS_REPO_SLUG.git gh-pages > /dev/null
fi