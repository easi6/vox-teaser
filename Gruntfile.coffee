'use strict'
mountFolder = (connect, dir) ->
  connect.static require('path').resolve dir

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    connect:
      server:
        options:
          port: 9999
          hostname: '*'
          base: 'dist'
          middleware: (connect) ->
            [ require('connect-livereload')(ignore:[]), mountFolder(connect, '.tmp'), mountFolder(connect, 'dist')]
    watch:
      options:
        livereload: true
      less:
        files:
          ['assets/styles/**/*.less']
        tasks: 'less'
        options:
          livereload: false
      coffee:
        files:
          ['assets/scripts/**/*.coffee']
        tasks: 'coffee'
        options:
          livereload: false
      jade:
        files:
          ['views/**/*.jade']
        tasks: 'jade'
        options:
          livereload: false
      img:
        files:
          ['assets/images/**/*']
        tasks: 'copy:img'
        options:
          livereload: false


      bootstrap:
        files:
          ['bootstrap/dist/**/*']
        tasks: 'copy:bootstrap'
        options:
          livereload: false

      dist:
        files: ['dist/**', 'dist/img/*.*', 'dist/css/*.*', 'dist/js/*.*']
    coffee:
      compile:
        files:
          "dist/js/main.js": "assets/scripts/main.coffee"
    less:
      development:
        options:
          paths: ["assets/styles"]
        files:
          'dist/css/main.css': 'assets/styles/main.less'
    open:
      # change to the port you're using
      server:
        path: "http://localhost:<%= connect.server.options.port %>?LR-verbose=true"
    jade:
      compile:
        files:
          "dist/index.html": ["views/index.jade"],
          "dist/terms.html": ["views/terms.jade"],
    copy:
      img:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/images'
            dest: 'dist/img/'
        ]

      bootstrap:
        files: [
          expand: true
          src: ['**']
          cwd: 'bower_components/bootstrap/dist'
          dest: 'dist/bootstrap/'
        ]

      main:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/images'
            dest: 'dist/img/'
          ,
            expand: true
            src: ['**.js']
            cwd: 'assets/scripts'
            dest: 'dist/js/'
          ,
            expand: true
            src: ['**.css']
            cwd: 'assets/styles'
            dest: 'dist/css/'
        ]
    clean: ['dist']

  grunt.registerTask 'server', [ 'clean', 'copy', 'jade', 'less', 'coffee', 'connect:server', 'open', 'watch' ]

