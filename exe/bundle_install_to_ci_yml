#!/usr/bin/env ruby
# ci.yml に "Install dependencies" ステップを追加するスクリプト

CI_YML_PATH = '.github/workflows/ci.yml'

# 追加するステップ
INSTALL_STEP = <<~YAML

      - name: Install dependencies
        run: bundle install --jobs 4 --retry 3
YAML

def add_install_dependencies_step
  unless File.exist?(CI_YML_PATH)
    puts "Error: #{CI_YML_PATH} が見つかりません"
    exit 1
  end

  content = File.read(CI_YML_PATH)
  lines = content.split("\n")
  
  # scan_js ジョブ内で処理
  in_scan_js_job = false
  setup_ruby_found = false
  insertion_index = nil
  
  lines.each_with_index do |line, index|
    # scan_js ジョブの開始を検出
    if line.match?(/^\s{2}scan_js:/)
      in_scan_js_job = true
      setup_ruby_found = false
      next
    end
    
    # 次のジョブが始まったら scan_js を抜ける
    if in_scan_js_job && line.match?(/^\s{2}\w+:/) && !line.match?(/^\s{2}scan_js:/)
      in_scan_js_job = false
    end
    
    # scan_js ジョブ内で "Set up Ruby" ステップを探す
    if in_scan_js_job && line.match?(/^\s+- name: Set up Ruby/)
      setup_ruby_found = true
    end
    
    # "Set up Ruby" の with ブロックの終わりを検出
    if in_scan_js_job && setup_ruby_found
      # bundler-cache: true の行の後に挿入
      if line.match?(/^\s+bundler-cache: true/)
        # 既に "Install dependencies" が存在するかチェック
        next_lines = lines[(index + 1)..(index + 5)]
        if next_lines.any? { |l| l.match?(/Install dependencies/) }
          puts "✓ 'Install dependencies' ステップは既に存在します"
          return
        end
        
        insertion_index = index + 1
        break
      end
    end
  end
  
  if insertion_index.nil?
    puts "Error: 挿入位置が見つかりませんでした"
    exit 1
  end
  
  # ステップを挿入
  lines.insert(insertion_index, INSTALL_STEP.strip)
  
  # ファイルに直接書き込み
  File.write(CI_YML_PATH, lines.join("\n") + "\n")
  
  puts "✓ 'Install dependencies' ステップを追加しました"
  puts "  位置: scan_js ジョブ内、'Set up Ruby' ステップの後"
end

# メイン処理
begin
  add_install_dependencies_step
  puts "\n完了しました！"
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
  exit 1
end
