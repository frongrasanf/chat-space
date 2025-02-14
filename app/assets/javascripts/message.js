$(function() {

  var wrapper = $("#wrapper");
  var refMessages;

  function buildHtml(message) {
    var htmlName = $('<div class="view__messages__message__name">').append(message.name);
    var htmlDate = $('<div class="view__messages__message__date">').append(message.date);
    var htmlBody = $('<div class="view__messages__message__body">').append(message.body);
    var element = $("<div>", { class: "view__messages__message" }).append(htmlName, htmlDate, htmlBody);
    if (message.image.url) {
      var htmlImage = document.createElement('img');
      htmlImage.src = message.image.url;
      element.append(htmlImage);
    }
    return element
  }

  //投稿機能の非同期化
  //submitされたときに発火し、HTML加工処理
  //投稿したメッセージのところまでスクロールが下がる

  $('#new__message').on('submit', function(e){
    e.preventDefault();
    var messageInput = $('.view__message--new__input');
    var fd = new FormData($(this).get(0));

    $.ajax({
      type: 'POST',
      url: './messages.json',
      data: fd,
      processData: false,
      contentType: false,
      dataType: 'json'
    })
    .done(function(message) {
      var element = buildHtml(message);
      wrapper.append(element);
      wrapper.animate({ scrollTop: wrapper[0].scrollHeight }, 'normal');
      messageInput.val('');
    })
    .fail(function() {
      alert('error');
    });
  });

  //自動更新機能
  //一定間隔でmessagesコントローラーのindexアクションにAjaxで通信する。
  // autoRefleshが呼ばれたとき、urlにmessagesを含んでいるときだけ自動更新する。

  function autoReflesh() {
    var url = window.location.href;
    if (url.match(/messages/)) {
      $.ajax({
        type: "GET",
        url: './messages.json',
        dataType: 'json'
      })
      .done(function(messages) {
        wrapper.empty();
        $.each(messages, function(i, message) {
          var refMessage = buildHtml(message);
          wrapper.append(refMessage);
        });
      });
    }
  };
  // var timer = setInterval(function() { autoReflesh() }, 3000);
});



