# frozen_string_literal: true

desc "Run all samples from examples/ folder"
task :examples do
  FileList["examples/*.rb"].each do |example|
    sh "ruby #{example}"
  end
end
