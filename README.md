# 使い方

## `rails new` 時点

### transfer_dir

`transfer_dir aaa bbb` を実行すると、dir "aaa" の内容を dir "bbb" へ移します。GitHub 上で project を作成し fetch した後に `rails new` を実施する場合に役立ちます。

### transfer_dir

`git_add_chmod aaa` を実行すると、aaa を git add した上で実行権限を付与します。aaa の部分は wildcard などの Ruby の filename 記法が使えます。

## `rails generate` 時点

### has_many

`rails generate scaffold exam student:references` の実行後、 `has_many exam student` と実行することで student.rb に has_many が設定されます。

### collection_select

`rails generate scaffold exam student:references` の実行後、 `collection_select exam student` と実行することで exam 編集時に student 一覧から選択できるようになります。

### show_parent

`rails generate scaffold exam student:references` の実行後、 `show_parent exam student` と実行することで exam 表示時に student 名称が表示されます。

### show_children

`rails generate scaffold exam student:references` の実行後、 `show_children exam student` と実行することで student 表示時に exam 一覧が表示されます。

