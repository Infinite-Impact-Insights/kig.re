

desc 'Deploy the HEAD to production'
task :deploy do
  sh 'ssh kig@kig.re -t -- bash -l -c /home/kig/workspace/kig.re/v2/_bin/deploy'
end
