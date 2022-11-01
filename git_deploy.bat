@echo off
echo "--------BEGIN--------"
git status
set /p msg=Comment:
git add .
git commit -m %msg%
git push -u origin hugo-main
cd public
git add .
git commit -m %msg%
git push -u origin gh-pages
cd ..
echo Push successfully ![%msg%]
echo "--------END--------"