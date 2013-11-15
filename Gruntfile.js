module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      jade: {
          files: ['views/**'],
          options: {
              livereload: true
          }
      },
      css: {
          files: ['public/sass/**'],
          tasks: ['compass'],
          options: {
              livereload: true,
              force: true
          }
      },
      coffee: {
        files: ['public/js/*.coffee'],
        tasks: 'coffee',
        options: {
          livereload: true,
          debounceDelay: 2000
        }
      }
    },
    coffee: {
      compile: {
        files: {
          'public/js/*.js': ['public/js/*.coffee'] // 1:1 compile
        }
      }
    },
    compass: { //Task
        dist: { //Target
            options: { //Target options
                sassDir: 'public/sass',
                cssDir: 'public/css',
                environment: 'production'
            }
        },
        dev: { //Another target
            options: {
                sassDir: 'public/sass',
                cssDir: 'public/css'
            }
        }
    },
    nodemon: {
      dev: {
        options: {
          file: 'server.coffee',
          ignoredFiles: ['README.md', 'node_modules/**', 'public/js/templates.js', '.DS_Store'],
          env: {
            PORT: '3000'
          }
        }
      }
    },
    concurrent: {
      target: {
        tasks: ['nodemon', 'watch'],
        options: {
          logConcurrentOutput: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');

  grunt.registerTask('default', ['compass', 'coffee', 'concurrent:target']);

}
