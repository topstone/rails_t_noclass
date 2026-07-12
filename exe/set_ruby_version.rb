#!/usr/bin/env ruby
# frozen_string_literal: true

# set-ruby-version.rb
#
# 使い方:
#   ruby set-ruby-version.rb 4.0.5   # バージョンを直接指定
#   ruby set-ruby-version.rb         # ./.ruby-version の内容を利用
#
# カレントディレクトリに存在する以下のファイルに対して、
# Ruby のバージョンを設定する。
#   - .ruby-version         (フル版, 例: ruby-4.0.5)
#   - Dockerfile            (フル版, 例: ARG RUBY_VERSION=4.0.5)
#   - .rubocop.yml          (メジャー.マイナー, 例: TargetRubyVersion: 4.0)
#   - .standard.yml         (メジャー.マイナー, 例: ruby_version: 4.0)
#   - *.gemspec             (メジャー.マイナー, 例: required_ruby_version = ">= 4.0")
#
# 存在しないファイルは変更しない（作成もしない）。

# --- バージョン文字列の分解 -------------------------------------------------

def split_version(version)
  full = version.strip
  parts = full.split(".")
  major_minor = parts.first(2).join(".")
  [full, major_minor]
end

def read_version_from_dot_ruby_version
  path = ".ruby-version"
  unless File.exist?(path)
    abort <<~MSG
      エラー: 引数が指定されておらず、#{path} も見つかりません。
      バージョンを引数で指定するか、#{path} を作成してください。
      例: ruby #{File.basename(__FILE__)} 4.0.5
    MSG
  end
  content = File.read(path).strip
  content.sub(/\Aruby-/, "")
end

# --- 実行対象バージョンの決定 ------------------------------------------------

raw_version = ARGV[0] || read_version_from_dot_ruby_version
full_version, major_minor = split_version(raw_version)

puts "設定するバージョン: フル版=#{full_version} / メジャー.マイナー=#{major_minor}"
puts

updated = []
unchanged = []
missing = []

# --- 各ファイルの更新処理 ---------------------------------------------------

def update_file(path, updated, unchanged, missing)
  unless File.exist?(path)
    missing << path
    return
  end

  content = File.read(path)
  new_content = yield(content)

  if new_content == content
    unchanged << path
  else
    File.write(path, new_content)
    updated << path
  end
end

# .ruby-version : ruby-4.0.5 のようなフル版
update_file(".ruby-version", updated, unchanged, missing) do |_content|
  "ruby-#{full_version}\n"
end

# Dockerfile : ARG RUBY_VERSION=4.0.5 のようなフル版
update_file("Dockerfile", updated, unchanged, missing) do |content|
  content.gsub(/(ARG\s+RUBY_VERSION=)\S+/, "\\1#{full_version}")
end

# .rubocop.yml : TargetRubyVersion: 4.0 のようなメジャー.マイナー
update_file(".rubocop.yml", updated, unchanged, missing) do |content|
  content.gsub(/(TargetRubyVersion:\s*)\S+/, "\\1#{major_minor}")
end

# .standard.yml : ruby_version: 4.0 のようなメジャー.マイナー
update_file(".standard.yml", updated, unchanged, missing) do |content|
  content.gsub(/(ruby_version:\s*)\S+/, "\\1#{major_minor}")
end

# *.gemspec : required_ruby_version = ">= 4.0" のようなメジャー.マイナー
gemspecs = Dir.glob("*.gemspec")
if gemspecs.empty?
  missing << "*.gemspec"
else
  gemspecs.each do |path|
    update_file(path, updated, unchanged, missing) do |content|
      content.gsub(/(required_ruby_version\s*=\s*")([^"]*)(")/) do
        prefix = Regexp.last_match(1)
        inner = Regexp.last_match(2)
        suffix = Regexp.last_match(3)
        new_inner = inner.sub(/\d+(?:\.\d+){1,2}/, major_minor)
        "#{prefix}#{new_inner}#{suffix}"
      end
    end
  end
end

# --- 結果表示 ---------------------------------------------------------------

puts "更新したファイル:" unless updated.empty?
updated.each { |f| puts "  ○ #{f}" }

puts "変更なし（既に同じ内容）:" unless unchanged.empty?
unchanged.each { |f| puts "  - #{f}" }

puts "見つからなかったファイル（スキップ）:" unless missing.empty?
missing.each { |f| puts "  × #{f}" }
