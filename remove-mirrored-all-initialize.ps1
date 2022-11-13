# 事前にsubに移行先のリポジトリを追加しておくこと

# まずすべてのブランチをローカルに取得
git fetch --all
git branch -r | grep -v -e master | sed -e 's% *origin/%%' | %{git branch --track $_ remotes/origin/$_ }
git fetch --all
git pull --all

# 移行開始
git push sub master
git branch | grep -v -e master| sed -e 's/ //g' | %{git checkout $_; $orphan=$_ + '_moved'; git checkout --orphan $orphan; git pull sub master; git add .; git commit -m 'Initial commit' ; git push sub $_ }