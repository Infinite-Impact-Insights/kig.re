require 'colored2'
require 'rake'
require 'erb'
require 'yaml'
require 'hashie/mash'

task :default => 'jekyll:preview'

namespace :jekyll do
  desc 'Generate a new post with the title provided as an argument'
  task :new, [ :title ] do | t, args |
    @title = args[:title]

    if @title.nil?
      err = "Error: " + "title is required.".red +
      "\nUsage: " + "rake 'jekyll:new[My Fancy New Title]'".bold.green
      raise err
    end

    file_title = @title.gsub(/ /, '_').gsub(/[^a-zA-Z0-9\-_]/, '').downcase
    filename="_posts/#{Time.now.strftime('%Y-%m-%d')}-#{file_title}.md"

    b = binding

    puts "Creating a new blog post!\n"

    puts "Filename: " + "#{filename}".bold.green
    puts "Title:    " + "'#{@title}'".bold.green

    File.open("#{filename}", 'w') do |f|
      f.puts(ERB.new(File.read('_templates/post.md.erb')).result(b))
    end
  end

  desc "Remove _site folder"
  task :clean do
    sh 'rm -rf _site'
  end

  desc 'Generate all static pages into _site folder'
  task :build do
    sh 'RUBYOPT="-W0" bundle exec jekyll build'
    sh 'chmod -R 755 _site/'
  end
  task :serve do
    sh 'RUBYOPT="-W0" bundle exec jekyll serve -H 0.0.0.0 --watch --trace'
  end
  task :browser do
    spawn 'sleep 3 && open http://localhost:4000'
  end
  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task :preview => [ :browser, :serve ]
end

def s title
  puts "\n#{title.upcase.yellow.bold}\n"
end

def image
  "#{@config.docker.image.user}/#{@config.docker.image.name}"
end
def container
  "#{@config.docker.container.name}-#{@config.docker.image.name}"
end

namespace :docker do
  task :config do
    @config = Hashie::Mash.new(YAML.load(File.read('_config.yml')))
  end

  desc 'Build Docker Image from a Dockerfile'
  task :build => [ :config, 'jekyll:build' ] do
    sh "cp _docker/Dockerfile.#{@config.docker.dockerfile} _site/Dockerfile"
    sh "cp _docker/nginx* _site/"
    sh "cd _site && docker build -t #{image} ."
  end

  desc "Run (and build) Docker image"
  task :run => [ :rm, :build ]   do
    sh "docker run --name #{container} -d -p 80:8080 #{image}"
  end

  desc "Start Docker Container"
  task :start => :build do
    sh "docker start #{container} "
  end

  desc "Stop docker container"
  task :stop => :config do
    sh "docker stop #{container}"
  end

  desc "Remove Docker container"
  task :rm => :config do
    begin
      unless %x(docker ps -a | grep #{container}).empty?
        sh "docker rm --force #{container}"
      end
      unless %x(docker images | grep #{image}).empty?
        #sh "docker rmi --force #{image}"
      end
    rescue nil
    end
  end

  desc "Report on status of the Docker container"
  task :status => :config do
    images = %x(docker images | egrep 'REPOSI|#{image}')
    unless images.empty?
      s 'Docker Images'
      puts images.green.bold
    end
    containers = %x(docker ps | egrep 'CONTAIN|#{container}')
    unless containers.empty?
      s 'Docker Containers'
      puts containers.cyan.bold
    end
  end
end

desc 'Deploy the HEAD to production'
task :deploy do
  sh 'ssh kig@kig.re -t -- bash -l -c /home/kig/workspace/kiguino.github.io/deploy'
end
