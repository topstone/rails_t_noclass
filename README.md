# 使い方

## Ruby, Ruby on Rails 共通

Ruby では `bundle gem --exe --test=rspec --ci=github --linter=standard ____` などの後に実施

Ruby on Rails では `rails new` 後に実施

### transfer_dir

`transfer_dir aaa aaa_` を実行すると、dir "aaa" の内容を dir "aaa_" へ移します。GitHub 上で project を作成し clone した後に `bundle gem` や `rails new` を実施する場合に役立ちます。

1. GitHub 上で repository "aaa" を作成
2. local PC へ clone
3. "aaa_" に rename
4. `bundle gem aaa`
5. `transfer_dir aaa aaa_`
6. aaa を削除
7. aaa_ を aaa に rename

### disable_autocrlf

`disable_autocrlf` を実行すると、`git config core.autocrlf false` を実行します。

### ignore_gemfile_lock

`ignore_gemfile_lock` を実行すると、.gitignore に /Gemfile.lock 行を追記します。

### comment_out_gemspec

`comment_out_gemspec` を実行すると、.gemspec 内で build に不要な行を comment out します。

`comment_out_gemspec "現在時刻を表示します。"` を実行すると、上記処理に加え、 .gemspec 内の SUMMARY 行に「現在時刻を表示します。」と設定します。

### shorten_shebang

`shorten_shebang aaa` を実行すると、aaa の1行目が shebang でありなおかつ「ruby.exe」であった場合に「ruby」に置き換えます。aaa の部分は wildcard などの Ruby の filename 記法が使えます。

Rails application であれば `shorten_shebang bin/*` とします。これをしないと GitHub Actions で "Permission denied" となります。

### git_add_chmod

`git_add_chmod aaa` を実行すると、aaa を git add した上で実行権限を付与します。aaa の部分は wildcard などの Ruby の filename 記法が使えます。

Rails application であれば `git_add_chmod bin` とします。これをしないと GitHub Actions で "Permission denied" となります。

なお、この操作を実施した直後に CLI で `git commit` することを推奨します。(MS-Windows 上で GitHub Desktop を使っている場合、気付かぬうちに実行許可属性が消されることがあります。)

### set_ruby_version

`set_ruby_version 4.0.5` を実行すると、既存 files (後述) に対して、「4.0.5」または「4.0」を設定します。

`set_ruby_version` を実行すると、既存 files (後述) に対して、.ruby-version の内容を元に ruby version を設定します。

#### 対象の files

* .rubocop.yml
* .ruby-version
* .standard.yml
* Dockerfile
* *.gemspec
### ruby_version_to_ci_yml

`ruby_version_to_ci_yml` を実行すると、.ruby-version の中身を読み込んで .github/workflows/ci.yml に書き込みます。(ci.yml に「ruby-version: file」という行があったら、 version を固定します。)

### bundle_exec_to_ci_yml

`bundle_exec_to_ci_yml` を実行すると、 .github/workflows/ci.yml 内の「run: bin/」を全て bundle exec 形式に変換します。

## `rails new` 後

### db_migrate_to_ci_yml

`db_migrate_to_ci_yml` を実行すると、 .github/workflows/ci.yml 内の test 実施直前に rails db:migrate を実行するようにします。

これをしないと GitHub Actions で "db/schema.rb doesn't exist yet." となります。

### system_test_if_exist

`system_test_if_exist` を実行すると、 .github/workflows/ci.yml 内の system test は test/system が存在する場合に限定します。

これをしないと GitHub Actions で system-test が失敗します。

## `rails generate` 後

### has_many

`rails generate scaffold exam student:references` の実行後、 `has_many exam student` と実行することで student.rb に has_many が設定されます。

### collection_select

`rails generate scaffold exam student:references` の実行後、 `collection_select exam student` と実行することで exam 編集時に student 一覧から選択できるようになります。

### show_parent

`rails generate scaffold exam student:references` の実行後、 `show_parent exam student` と実行することで exam 表示時に student 名称が表示されます。

### show_children

`rails generate scaffold exam student:references` の実行後、 `show_children exam student` と実行することで student 表示時に exam 一覧が表示されます。

