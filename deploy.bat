@echo off
echo "--------BEGIN--------"
git status
set /p msg=Comment:
git add .
git commit -m %msg%
git push -u origin hugo-main --force
cd public
git add .
git commit -m %msg%
git push -u origin gh-pages --force
cd ..
echo Push successfully ![%msg%]
echo "--------END--------"