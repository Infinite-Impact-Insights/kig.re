require 'colored2'
require 'rake'
task :default => 'jekyll:preview'
namespace :jekyll do
  task :clean do
    sh 'rm -rf _site'
  end
  desc 'Generate all static pages into _site folder'
  task :build => :clean do
    sh 'bundle exec jekyll build'
    sh 'chmod -R 755 _site/'
  end
  task :serve do
    sh 'bundle exec jekyll serve --watch'
  end
  task :browser do
    spawn 'sleep 2 && open http://localhost:4000'
  end
  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task :preview => [ :browser, :serve ]
end

def s title
  puts "\n#{title.upcase.yellow.bold}\n"
end

namespace :docker do
  Config = Struct.new(:image_name, :container_name)
  @config = Config.new('reinventone/kigre', 'kigre')

  task :build => [ 'jekyll:build' ] do
    sh 'cp _docker/Dockerfile.static-only _site/Dockerfile'
    sh "cd _site && docker build -t #{@config.image_name} ."
  end
  task :run => :build do
    sh "docker run --name #{@config.container_name} -d -p 8080:80 #{@config.image_name}"
  end
  task :start do
    sh "docker start #{@config.container_name} "
  end
  task :stop do
    sh "docker stop #{@config.container_name}"
  end
  task :rm do
    begin
      unless %x(docker ps -a | grep #{@config.container_name}).empty?
        sh "docker rm --force #{@config.container_name}"
      end
      unless %x(docker images | grep #{@config.image_name}).empty?
        sh "docker rmi #{@config.image_name}"
      end
    rescue nil
    end
  end
  task :status do
    images = %x(docker images | egrep 'REPOSI|#{@config.image_name}')
    unless images.empty?
      s 'Docker Images'
      puts images.green.bold
    end
    containers = %x(docker ps | egrep 'CONTAIN|#{@config.container_name}')
    unless containers.empty?
      s 'Docker Containers'
      puts containers.cyan.bold
    end
  end
end
