require 'colored2'
require 'rake'
require 'erb'

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
  
  
  task :clean do
    sh 'rm -rf _site'
  end
  
  
  desc 'Generate all static pages into _site folder'
  task :build => :clean do
    sh 'bundle exec jekyll build'
    sh 'chmod -R 755 _site/'
  end
  task :serve do
    sh 'bundle exec jekyll serve --watch --trace'
  end
  task :browser do 
    spawn 'sleep 2 && open http://localhost:4000'
  end
  desc 'Starts Jekyll in serve --watch mode and opens the browser'
  task :preview => [ :browser, :serve ]
end

desc 'Deploy the HEAD to production'
task :deploy do
  sh 'ssh kig@kig.re -t -- bash -l -c /home/kig/workspace/kiguino.github.io/deploy'
end

def s title
  puts "\n#{title.upcase.yellow.bold}\n"
end

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
