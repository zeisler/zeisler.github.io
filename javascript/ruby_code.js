var RubyCode = {
  load: function (path, name){
    $(document).ready(function() {
      $.get(path, function( data ) {
        $('pre code#' + name).each(function(i, block) {
          $(block).html(data);
          hljs.highlightBlock(block);
        });
      });
    });
  }
};
