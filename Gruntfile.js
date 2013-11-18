module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      jade: {
          files: ['views/**']
      },
      sass: {
          files: ['public/sass/**'],
          tasks: ['compass']
      },
      livereload: {
        options: {livereload: true },
        files: ['public/**/*']
      },
      coffee: {
        files: ['public/js/*.coffee'],
        tasks: 'coffee'
      }
    },
    coffee: {
      glob_to_multiple: {
        expand: true,
        flatten: true,
        cwd: 'public/js',
        src: ['*.coffee'],
        dest: 'public/js/',
        ext: '.js'
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
