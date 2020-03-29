require_relative '../task_helper'

# rubocop: disable Style/MixinUsage
extend(TaskHelper)

namespace :docker do
  task :config do
    @config = Hashie::Mash.new(YAML.safe_load(File.read('_config.yml')))
  end

  desc 'Build Docker Image from a Dockerfile'
  task build: [:config, 'jekyll:build'] do
    sh "cp _docker/Dockerfile.#{@config.docker.dockerfile} _site/Dockerfile"
    sh 'cp _docker/nginx* _site/'
    sh "cd _site && docker build -t #{image} ."
  end

  desc 'Run (and build) Docker image'
  task run: [:rm, :build] do
    sh "docker run --name #{container} -d -p 80:8080 #{image}"
  end

  desc 'Push This Docker image'
  task push: [:build] do
    sh "docker push #{image}"
  end

  desc 'Start Docker Container'
  task start: :build do
    sh "docker start #{container} "
  end

  desc 'Stop docker container'
  task stop: :config do
    sh "docker stop #{container}"
  end

  desc 'Remove Docker container'
  task rm: :config do
    unless `docker ps -a | grep #{container}`.empty?
      sh "docker rm --force #{container}"
    end
    unless `docker images | grep #{image}`.empty?
      # sh "docker rmi --force #{image}"
    end
  rescue StandardError
    nil
  end

  desc 'Report on status of the Docker container'
  task status: :config do
    images = `docker images | egrep 'REPOSI|#{image}'`
    unless images.empty?
      header 'Docker Images'
      puts images.green.bold
    end
    containers = `docker ps | egrep 'CONTAIN|#{container}'`
    unless containers.empty?
      header 'Docker Containers'
      puts containers.cyan.bold
    end
  end
end
