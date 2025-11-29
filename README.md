## 使い方

### has_many

`rails generate scaffold exam student:references` の実行後、 `has_many exam student` と実行することで student.rb に has_many が設定されます。

### collection_select

`rails generate scaffold exam student:references` の実行後、 `collection_select exam student` と実行することで exam 編集時に student 一覧から選択できるようになります。。

