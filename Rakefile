require 'colorize'
require 'rake'
task :default => 'jekyll:preview'
namespace :jekyll do
  task :clean do
    sh 'rm -rf _site'
  end
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
  desc 'Starts Jekyll in watch mode and opens the browser'
  task :preview => [ :browser, :serve ]
end

Config = Struct.new(:image_name, :container_name)
@config = Config.new('kiguino-nginx', 'kiguino-nginx-container')

namespace :docker do
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
    images = %x(docker images | grep #{@config.image_name})
    puts "IMAGES:"
    puts images unless images.empty?
    containers = %x(docker ps | grep #{@config.container_name})
    puts "CONTAINERS:"
    puts containers unless containers.empty?
  end
end
