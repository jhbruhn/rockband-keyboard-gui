module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    coffeelint: {
      app: ['coffee/**/*.coffee']
    },

    coffee: {
      app: {
        files: {
          'build/js/app.js': ['coffee/**/*.coffee']
        }
      }
    }
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('build-coffeescript', ['coffeelint', 'coffee:app']);
}
