$('.fancybox').attr('rel','gallery').fancybox({
  maxWidth: ($(window).width()-376),
  margin: [10, 352, 10, 20],
  padding: 2,
  closeBtn: false,
  closeEffect: 'none',
  openEffect: 'none',
  prevEffect: 'none',
  nextEffect: 'none',
  tpl: {
    next: '<a title="Следующая" class="fancybox-nav fancybox-next" href="javascript:;"><span></span></a>',
    prev: '<a title="Предыдущая" class="fancybox-nav fancybox-prev" href="javascript:;"><span></span></a>'
  },
  helpers: {
    title: {
      type: 'outside'
    },
    buttons: {
      tpl: '<div id="fancybox-buttons"><ul><li><a class="btnPrev linkedImage" title="Предыдущая" href="javascript:;">Предыдущая</a></li><li><a class="btnPlay linkedImage" title="Слайд-шоу" href="javascript:;">Слайд-шоу</a></li><li><a class="btnNext linkedImage" title="Следующая" href="javascript:;">Следующая</a></li><li><a class="btnClose linkedImage" title="Закрыть" href="javascript:$.fancybox.close();">Закрыть</a></li></ul></div>'
    },
    overlay: {
      speedIn: 0,
      speedOut: 0,
      css: { 'background': 'rgba(22, 22, 22, 0.93)' }
    }
  },
  beforeLoad: function() {
    var el, id = $(this.element).data('title-id');
    if (id) {
      el = $('#' + id);
      if (el.length) {
        this.title = el.html();
      }
    }
  },
  afterShow: function() {
    var comments = $('.select_simple_comments').eq(this.index).html();
    $("<div id='simple_comments_container'></div>").html(comments).appendTo('.fancybox-overlay');
  }
});

$('.fancybox_menu_view').fancybox({
  padding: 2,
  closeEffect: 'none',
  openEffect: 'none',
  tpl: {
    closeBtn: '<a title="Закрыть" class="fancybox-item fancybox-close" href="javascript:;"></a>',
    next: '<a title="Следующая" class="fancybox-nav fancybox-next" href="javascript:;"><span></span></a>',
    prev: '<a title="Предыдущая" class="fancybox-nav fancybox-prev" href="javascript:;"><span></span></a>'
  },
});